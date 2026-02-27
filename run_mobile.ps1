$env:JAVA_HOME = 'C:\Program Files\Microsoft\jdk-17.0.18.8-hotspot'
$env:ANDROID_HOME = 'C:\Android\Sdk'
$env:ANDROID_SDK_ROOT = 'C:\Android\Sdk'
$env:PATH = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\cmdline-tools\latest\bin;$env:PATH"

echo "Launching Supa-app on Realme C51 (RMX3830)..."
echo "Note: The first build might take a few minutes."

& X:\bin\flutter.bat run -d 10FEB401NM00082 --no-pub --gradle-project-property android.builder.sdkDownload=false
