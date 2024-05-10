import Vrtcal_Adapters_Wrapper_Parent
import VrtcalSDK

class VrtcalAdaptersWrapper: NSObject, AdapterWrapperProtocol {
    
    var appLogger: Logger
    var sdkEventsLogger: Logger
    var sdk = SDK.vrtcal
    var delegate: AdapterWrapperDelegate

    var vrtInterstitial: VRTInterstitial?
    var interstitialReady = false
    
    var serverUrl: URL {
        let strUrl = UserDefaults.standard.string(forKey: "serverUrl") ?? "https://adplatform.vrtcal.com"
        return URL(string: strUrl)!
    }
    
    var appId: Int {
        let appId = UserDefaults.standard.integer(forKey: "appId")
        
        guard appId != 0 else {
            // TwitMore's App ID
            return 11050
        }
        
        return appId
    }
    
    var daastMode: Bool {
        UserDefaults.standard.bool(forKey: "daastMode")
    }
    
    required init(
        appLogger: Logger,
        sdkEventsLogger: Logger,
        delegate: AdapterWrapperDelegate
    ) {
        self.appLogger = appLogger
        self.sdkEventsLogger = sdkEventsLogger
        self.delegate = delegate
    }
    
    func initializeSdk() {
        appLogger.log("serverUrl: \(serverUrl), appId: \(appId)")
        
        //VRTLog.singleton.debugMode = true
        VrtcalSDK.setServerUrl(serverUrl)
        VrtcalSDK.initializeSdk(
            withAppId: UInt(appId),
            sdkDelegate: self
        )
    }
    
    func handle(adTechConfig: AdTechConfig) {
        
        let zoneId = Int(adTechConfig.adUnitId) ?? 0
        
        switch adTechConfig.placementType {
            case .banner:
                appLogger.log("Vrtcal Banner")
                let vrtBanner = VRTBanner()
                vrtBanner.adDelegate = self
                
            
                if daastMode {
                    vrtBanner.isDaast = true
                    vrtBanner.addOffScreenConstraints()
                } else {
                    vrtBanner.addFillSuperViewContraints()
                }

                let zoneId = Int(adTechConfig.adUnitId) ?? 0
                vrtBanner.loadAd(UInt(zoneId))
            
                delegate.adapterWrapperDidProvide(banner: vrtBanner)
                
            case .interstitial:
                appLogger.log("Vrtcal Interstitial")
            
                self.vrtInterstitial = VRTInterstitial()
                vrtInterstitial?.adDelegate = self
                vrtInterstitial?.loadAd(UInt(zoneId))

            case .rewardedVideo:
                sdkEventsLogger.log("rewardedVideo not supported for Vrtcal")
                
            case .showDebugView:
                sdkEventsLogger.log("showDebugView not supported for Vrtcal")
        }
    }
    
    func showInterstitial() -> Bool {
        guard let vrtInterstitial, interstitialReady else {
            return false
        }

        interstitialReady = false
        vrtInterstitial.showAd()
        return true
    }
    
    func destroyInterstitial() {
        vrtInterstitial = nil
    }
}

extension VrtcalAdaptersWrapper: VrtcalSdkDelegate {
    func sdkInitializationFailedWithError(_ error: Error) {
        appLogger.log("error: \(error)")
    }
    
    func sdkInitialized() {
        appLogger.log()
    }
}

//MARK: VRTBannerDelegate
extension VrtcalAdaptersWrapper: VRTBannerDelegate {
    
    func vrtBannerAdLoaded(
        _ vrtBanner: VRTBanner,
        withAdSize adSize: CGSize
    ) {
        appLogger.log("size: \(adSize)")
        
        if daastMode {
            vrtBanner.playDAAST()
        }
    }
    
    func vrtBannerAdFailedToLoad(_ vrtBanner: VRTBanner, error: Error) {
        appLogger.log("error: \(error)")
    }
    
    func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        appLogger.log()
    }
    
    func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        appLogger.log()
    }
    
    func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        appLogger.log()
    }
    
    func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        appLogger.log()
    }
    
    func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        appLogger.log()
    }
    
    func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        appLogger.log()
    }
    
    func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        appLogger.log()
    }
    
    func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        appLogger.log()
    }
    
    func vrtViewControllerForModalPresentation() -> UIViewController {
        let ret = UIApplication.shared.keyWindow?.rootViewController
        return ret!
    }
}
    
    
//MARK: VRTInterstitialDelegate
extension VrtcalAdaptersWrapper: VRTInterstitialDelegate {
    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
        interstitialReady = true
    }
    
    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        appLogger.log("error: \(error)")
        interstitialReady = false
    }
    
    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        appLogger.log()
    }
    
    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
    
    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        appLogger.log()
    }
}
