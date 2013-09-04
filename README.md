========================================================================================
DESCRIPTION :
========================================================================================

AirMobileFramework is a framework that let you easily create mobile content using Adobe Air and Flash DisplayList to target iOS/Android devices (and even desktop).

========================================================================================
WHAT DOES IT CONTAINS AND WHAT DOES IT PROVIDES YOU :
========================================================================================
This framework also provide a Adobe Flash extension to manage/create your projects quickly :
. It will generate your project tree including framework sources.
. It will even make it easier to add new Pages/Modules to your project by adding nodes to application's xml that describe how's your app is working.
. It will also declare your pages' classes as needed in com.app.Main.as :: function registerPagesClass()
. Finally, it will create your pages' classes extending the right needed classes.
. Moreover, extension is made to help you import the project in FDT

========================================================================================
WHAT IF YOU DON'T USE THE EXTENSION :
========================================================================================

If you doesn't want to use framework extension :
. You also can declare your classes in Main.as using the following line :
	registerClassAlias("[PageClassName]", [PageClassPackage].[PageClassName]);
	ex.: registerClassAlias("HomePage", com.app.pages.home.HomePage);
. You can add your page's assets in bin/xml/appConfig.xml like this in <pages> node :
	<[PageClassName] dependencies="OneDependentModule, OneAnother" />
		<[AssetType] id="[AssetId]" path="[optional AssetPath : shared or localized by language]" src="[AssetSourcePath]" />
	</[PageClassName]>
. Your page's class have to extend fwk.app.pages.AbstractPage (implementing fwk.app.pages.IPage)

========================================================================================
PACKAGING YOUR APP :
========================================================================================

- Packaging ANDROID APK using Terminal (Mac OS) or MsDOS Commands :
/[path to Air sdk from root]/bin/adt -package -target apk-captive-runtime -storetype pkcs12 -keystore /[path to certificate from root]/[certificateName].p12 -storepass [certificatePassword] /[path to packaged app target from root]/[appName].apk /[path to app descriptor XML from root]/[main swf fileName]-app.xml -C /[path to folder containing swf files] [main swf fileName].swf -C /[path to any other resources folder or file like icon, external library, image folder] [name of the folder or file]


- EXAMPLE :
/Users/renaud.cousin/Documents/Workspace/__SDKs__/flex_sdk_4.6.0.23201B_Air_sdk_3.2/bin/adt -package -target apk-captive-runtime -storetype pkcs12 -keystore /Users/renaud.cousin/Documents/Workspace/SampleApp/AirMobileFramework.p12 -storepass AbsolutRenal /Users/renaud.cousin/Documents/Workspace/SampleApp/bin/SampleApp.apk /Users/renaud.cousin/Documents/Workspace/SampleApp/bin/Main-app.xml -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin Main.swf -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin Icone48x48.png -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin Icone72x72.png -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin appLibrary.swf -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin languages -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin xml -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin videos -C /Users/renaud.cousin/Documents/Workspace/SampleApp/bin images

========================================================================================
PROVIDED CERTIFICATE'S PASSWORD : AbsolutRenal
========================================================================================