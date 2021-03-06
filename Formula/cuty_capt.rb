class CutyCapt < Formula
  desc "Converts web pages to vector/bitmap images using WebKit"
  homepage "http://cutycapt.sourceforge.net/"
  #url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz"
  #sha256 "cf85226a25731aff644f87a4e40b8878154667a6725a4dc0d648d7ec2d842264"
  url 'https://github.com/hoehrmann/CutyCapt', :using => :git, :revision => 'bea8c78'
  version "0.0.10"

  # Update to svn version 10
  #patch :DATA

  depends_on "qt"

  def install
    system "qmake", "CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end

  test do
    system "#{bin}/CutyCapt", "--url=http://brew.sh", "--out=brew.png"
    assert File.exist? "brew.png"
  end
end

__END__
diff --git a/CutyCapt.cpp b/CutyCapt.cpp
index c0839a6..c732cb9 100644
--- a/CutyCapt.cpp
+++ b/CutyCapt.cpp
@@ -2,13 +2,18 @@
 //
 // CutyCapt - A Qt WebKit Web Page Rendering Capture Utility
 //
-// Copyright (C) 2003-2010 Bjoern Hoehrmann <bjoern@hoehrmann.de>
+// Copyright (C) 2003-2013 Bjoern Hoehrmann <bjoern@hoehrmann.de>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.
 //
+// This program is free software; you can redistribute it and/or
+// modify it under the terms of the GNU Lesser General Public
+// License as published by the Free Software Foundation; either
+// version 2.1 of the License, or (at your option) any later version.
+//
 // This program is distributed in the hope that it will be useful,
 // but WITHOUT ANY WARRANTY; without even the implied warranty of
 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@@ -22,10 +27,15 @@
 #include <QtWebKit>
 #include <QtGui>
 #include <QSvgGenerator>
+
+#if QT_VERSION < 0x050000
 #include <QPrinter>
+#endif
+
 #include <QTimer>
 #include <QByteArray>
 #include <QNetworkRequest>
+#include <QNetworkProxy>
 #include "CutyCapt.hpp"
 
 #if QT_VERSION >= 0x040600 && 0
@@ -51,7 +61,9 @@ static struct _CutyExtMap {
   { CutyCapt::PsFormat,          ".ps",         "ps"    },
   { CutyCapt::InnerTextFormat,   ".txt",        "itext" },
   { CutyCapt::HtmlFormat,        ".html",       "html"  },
+#if QT_VERSION < 0x050000
   { CutyCapt::RenderTreeFormat,  ".rtree",      "rtree" },
+#endif
   { CutyCapt::JpegFormat,        ".jpeg",       "jpeg"  },
   { CutyCapt::PngFormat,         ".png",        "png"   },
   { CutyCapt::MngFormat,         ".mng",        "mng"   },
@@ -149,10 +161,13 @@ CutyPage::setAttribute(QWebSettings::WebAttribute option,
 // TODO: Consider merging some of main() and CutyCap
 
 CutyCapt::CutyCapt(CutyPage* page, const QString& output, int delay, OutputFormat format,
-                   const QString& scriptProp, const QString& scriptCode) {
+                   const QString& scriptProp, const QString& scriptCode, bool insecure,
+                   bool smooth) {
   mPage = page;
   mOutput = output;
   mDelay = delay;
+  mInsecure = insecure;
+  mSmooth = smooth;
   mSawInitialLayout = false;
   mSawDocumentComplete = false;
   mFormat = format;
@@ -226,6 +241,15 @@ CutyCapt::Delayed() {
 }
 
 void
+CutyCapt::handleSslErrors(QNetworkReply* reply, QList<QSslError> errors) {
+  if (mInsecure) {
+    reply->ignoreSslErrors();
+  } else {
+    // TODO: what to do here instead of hanging?
+  }
+}
+
+void
 CutyCapt::saveSnapshot() {
   QWebFrame *mainFrame = mPage->mainFrame();
   QPainter painter;
@@ -265,15 +289,23 @@ CutyCapt::saveSnapshot() {
       mainFrame->print(&printer);
       break;
     }
-    case RenderTreeFormat:
+#if QT_VERSION < 0x050000
+    case RenderTreeFormat: {
+      QFile file(mOutput);
+      file.open(QIODevice::WriteOnly | QIODevice::Text);
+      QTextStream s(&file);
+      s.setCodec("utf-8");
+      s << mainFrame->renderTreeDump();
+      break;
+    }
+#endif
     case InnerTextFormat:
     case HtmlFormat: {
       QFile file(mOutput);
       file.open(QIODevice::WriteOnly | QIODevice::Text);
       QTextStream s(&file);
       s.setCodec("utf-8");
-      s << (mFormat == RenderTreeFormat ? mainFrame->renderTreeDump() :
-            mFormat == InnerTextFormat  ? mainFrame->toPlainText() :
+      s << (mFormat == InnerTextFormat  ? mainFrame->toPlainText() :
             mFormat == HtmlFormat       ? mainFrame->toHtml() :
             "bug");
       break;
@@ -281,6 +313,14 @@ CutyCapt::saveSnapshot() {
     default: {
       QImage image(mPage->viewportSize(), QImage::Format_ARGB32);
       painter.begin(&image);
+#if QT_VERSION >= 0x050000
+      if (mSmooth) {
+        painter.setRenderHint(QPainter::SmoothPixmapTransform);
+        painter.setRenderHint(QPainter::Antialiasing);
+        painter.setRenderHint(QPainter::TextAntialiasing);
+        painter.setRenderHint(QPainter::HighQualityAntialiasing);
+      }
+#endif
       mainFrame->render(&painter);
       painter.end();
       // TODO: add quality
@@ -333,6 +373,10 @@ CaptHelp(void) {
     "  --expect-alert=<string>        Try waiting for alert(string) before capture \n"
     "  --debug-print-alerts           Prints out alert(...) strings for debugging. \n"
 #endif
+#if QT_VERSION >= 0x050000
+    "  --smooth                       Attempt to enable Qt's high-quality settings.\n"
+#endif
+    "  --insecure                     Ignore SSL/TLS certificate errors            \n"
     " -----------------------------------------------------------------------------\n"
     "  <f> is svg,ps,pdf,itext,html,rtree,png,jpeg,mng,tiff,gif,bmp,ppm,xbm,xpm    \n"
     " -----------------------------------------------------------------------------\n"
@@ -347,7 +391,7 @@ CaptHelp(void) {
     " This an experimental and easily abused and misused feature. Use with caution.\n"
     " -----------------------------------------------------------------------------\n"
 #endif
-    " http://cutycapt.sf.net - (c) 2003-2010 Bjoern Hoehrmann - bjoern@hoehrmann.de\n"
+    " http://cutycapt.sf.net - (c) 2003-2013 Bjoern Hoehrmann - bjoern@hoehrmann.de\n"
     "");
 }
 
@@ -357,11 +401,13 @@ main(int argc, char *argv[]) {
   int argHelp = 0;
   int argDelay = 0;
   int argSilent = 0;
+  int argInsecure = 0;
   int argMinWidth = 800;
   int argMinHeight = 600;
   int argMaxWait = 90000;
   int argVerbosity = 0;
-  
+  int argSmooth = 0;
+
   const char* argUrl = NULL;
   const char* argUserStyle = NULL;
   const char* argUserStylePath = NULL;
@@ -402,6 +448,16 @@ main(int argc, char *argv[]) {
       argVerbosity++;
       continue;
 
+    } else if (strcmp("--insecure", s) == 0) {
+      argInsecure = 1;
+      continue;
+
+#if QT_VERSION >= 0x050000
+    } else if (strcmp("--smooth", s) == 0) {
+      argSmooth = 1;
+      continue;
+#endif
+
 #if CUTYCAPT_SCRIPT
     } else if (strcmp("--debug-print-alerts", s) == 0) {
       page.setPrintAlerts(true);
@@ -594,7 +650,8 @@ main(int argc, char *argv[]) {
     }
   }
 
-  CutyCapt main(&page, argOut, argDelay, format, scriptProp, scriptCode);
+  CutyCapt main(&page, argOut, argDelay, format, scriptProp, scriptCode,
+                !!argInsecure, !!argSmooth);
 
   app.connect(&page,
     SIGNAL(loadFinished(bool)),
@@ -648,6 +705,11 @@ main(int argc, char *argv[]) {
     SLOT(JavaScriptWindowObjectCleared()));
 #endif
 
+  app.connect(page.networkAccessManager(),
+    SIGNAL(sslErrors(QNetworkReply*, QList<QSslError>)),
+    &main,
+    SLOT(handleSslErrors(QNetworkReply*, QList<QSslError>)));
+
   if (!body.isNull())
     page.mainFrame()->load(req, method, body);
   else
diff --git a/CutyCapt.hpp b/CutyCapt.hpp
index b7c26eb..15f3864 100644
--- a/CutyCapt.hpp
+++ b/CutyCapt.hpp
@@ -1,5 +1,9 @@
 #include <QtWebKit>
 
+#if QT_VERSION >= 0x050000
+#include <QtWebKitWidgets>
+#endif
+
 class CutyCapt;
 class CutyPage : public QWebPage {
   Q_OBJECT
@@ -40,7 +44,9 @@ public:
            int delay,
            OutputFormat format,
            const QString& scriptProp,
-           const QString& scriptCode);
+           const QString& scriptCode,
+           bool insecure,
+           bool smooth);
 
 private slots:
   void DocumentComplete(bool ok);
@@ -48,6 +54,7 @@ private slots:
   void JavaScriptWindowObjectCleared();
   void Timeout();
   void Delayed();
+  void handleSslErrors(QNetworkReply* reply, QList<QSslError> errors);
 
 private:
   void TryDelayedRender();
@@ -63,4 +70,6 @@ protected:
   QObject*     mScriptObj;
   QString      mScriptProp;
   QString      mScriptCode;
+  bool         mInsecure;
+  bool         mSmooth;
 };
diff --git a/CutyCapt.pro b/CutyCapt.pro
index 5064a20..10dda79 100644
--- a/CutyCapt.pro
+++ b/CutyCapt.pro
@@ -3,6 +3,10 @@ SOURCES   =  CutyCapt.cpp
 HEADERS   =  CutyCapt.hpp
 CONFIG   +=  qt console
 
+greaterThan(QT_MAJOR_VERSION, 4): {
+  QT       +=  webkitwidgets
+}
+
 contains(CONFIG, static): {
   QTPLUGIN += qjpeg qgif qsvg qmng qico qtiff
   DEFINES  += STATIC_PLUGINS
