//https://superuser.com/questions/13518/change-the-default-sorting-order-in-thunderbird
// 2 is descendant, 21 is ID (Order Received), 18 is Date
user_pref("mailnews.default_news_sort_order", 2);
user_pref("mailnews.default_news_sort_type", 18);
user_pref("mailnews.default_sort_order", 2);
user_pref("mailnews.default_sort_type", 18);
user_pref("fission.autostart", false);
user_pref("dom.ipc.processCount.webIsolated", 1);
user_pref("dom.ipc.processCount", 1);
user_pref("mailnews.start_page.enabled", false);
user_pref("browser.newtabpage.enabled", false);

/*** [SECTION 0200]: GEOLOCATION / LANGUAGE / LOCALE ***/
user_pref("_user.js.parrot", "0200 syntax error: the parrot's definitely deceased!");
/* 0201: use Mozilla geolocation service instead of Google if permission is granted [FF74+]
 * Optionally enable logging to the console (defaults to false) ***/
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
   // user_pref("geo.provider.network.logging.enabled", true); // [HIDDEN PREF]
/* 0202: disable using the OS's geolocation service ***/
user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
user_pref("geo.provider.use_corelocation", false); // [MAC]
user_pref("geo.provider.use_gpsd", false); // [LINUX]
user_pref("geo.provider.use_geoclue", false); // [FF102+] [LINUX]
/* 0210: set preferred language for displaying pages
 * [SETTING] General > Language & Appearance > Language > Choose the language used to display...
 * [TEST] https://addons.mozilla.org/about ***/
user_pref("intl.accept_languages", "en-US, en");
/* 0210b: Set dictionary to US ***/
user_pref("spellchecker.dictionary", "en-US");
/* 0211: use en-US locale regardless of the system or region locale
 * [SETUP-WEB] May break some input methods e.g xim/ibus for CJK languages [1]
 * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=867501,1629630 ***/
user_pref("javascript.use_us_english_locale", true); // [HIDDEN PREF]

/*** [SECTION 0300]: QUIETER BIRD ***/
user_pref("_user.js.parrot", "0300 syntax error: the parrot's not pinin' for the fjords!");
/** RECOMMENDATIONS ***/
/* 0320: disable recommendation pane in about:addons (uses Google Analytics) ***/
user_pref("extensions.getAddons.showPane", false); // [HIDDEN PREF]
/* 0321: disable recommendations in about:addons' Extensions and Themes panes [FF68+] ***/
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

/** TELEMETRY ***/
/* 0330: disable new data submission [FF41+]
 * If disabled, no policy is shown or upload takes place, ever
 * [1] https://bugzilla.mozilla.org/1195552
 * [2] https://searchfox.org/comm-esr115/source/mail/components/telemetry/README.md#165 ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
/* 0331: disable Health Reports
 * [SETTING] Privacy & Security > Thunderbird Data Collection and Use > Allow Thunderbird to send technical... ***/
user_pref("datareporting.healthreport.uploadEnabled", false);
/* 0332: disable telemetry
 * The "unified" pref affects the behavior of the "enabled" pref
 * - If "unified" is false then "enabled" controls the telemetry module
 * - If "unified" is true then "enabled" only controls whether to record extended data
 * [NOTE] "toolkit.telemetry.enabled" is now LOCKED to reflect prerelease (true) or release builds (false) [2]
 * [1] https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html
 * [2] https://medium.com/georg-fritzsche/data-preference-changes-in-firefox-58-2d5df9c428b5 ***/
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false); // see [NOTE]
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false); // [FF55+]
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false); // [FF55+]
user_pref("toolkit.telemetry.updatePing.enabled", false); // [FF56+]
user_pref("toolkit.telemetry.bhrPing.enabled", false); // [FF57+] Background Hang Reporter
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false); // [FF57+]
/* 0333: disable Telemetry Coverage
 * [1] https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/ ***/
user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.opt-out", true); // [FF64+] [HIDDEN PREF]
user_pref("toolkit.coverage.endpoint.base", "");
/* 0334: disable PingCentre telemetry (used in several System Add-ons) [FF57+]
 * Defense-in-depth: currently covered by 0331 ***/
user_pref("browser.ping-centre.telemetry", false);

/** STUDIES ***/
/* 0340: disable Studies
 * [NOTE] This option is missing from Thunderbird's preferences panel (hidden?) ***/
user_pref("app.shield.optoutstudies.enabled", false);
/* 0341: disable Normandy/Shield [FF60+]
 * Shield is a telemetry system that can push and test "recipes"
 * [1] https://mozilla.github.io/normandy/ ***/
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/
/* 0350: disable Crash Reports ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false); // [FF44+]
   // user_pref("browser.crashReports.unsubmittedCheck.enabled", false); // [FF51+] [DEFAULT: false]
/* 0351: enforce no submission of backlogged Crash Reports [FF58+]
 * [SETTING] Privacy & Security > Thunderbird Data Collection and Use > Allow Thunderbird to send backlogged crash reports... ***/
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false); // [DEFAULT: false]

/** OTHER ***/
/* 0360: disable Captive Portal detection
 * [1] https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy ***/
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false); // [FF52+]
/* 0361: disable Network Connectivity checks [FF65+]
 * [1] https://bugzilla.mozilla.org/1460537 ***/
user_pref("network.connectivity-service.enabled", false);
/* 0370: disable UI instrumentation ***/
user_pref("mail.instrumentation.postUrl", "");
user_pref("mail.instrumentation.askUser", false);
user_pref("mail.instrumentation.userOptedIn", false);
/* 0371: disable about:rights notification on fresh profiles
 * When a profile is loaded for the first time, a bottom notification appears with a button
 * showing "Know your rights...". If clicked, the _special_ page about:rights appears.
 * When `mail.rights.override` is unset (default), Thunderbird falls-back on `mail.rights.version`
 * value. If it's unset (default too) or lower than the current version, notification is displayed.
 * false=always show the notification
 * true=never show the notification
 * [1] https://searchfox.org/comm-esr102/source/mail/base/content/specialTabs.js#1266 ***/
user_pref("mail.rights.override", true);  // [DEFAULT: unset]
   // user_pref("mail.rights.version", 1);  // [DEFAULT: unset]
/* 0372: allow Thunderbird usage without any configured email account [SETUP-INSTALL]
 * [NOTE] Only enable this if you don't plan to use emails at all and want to hide the account setup ***/
   // user_pref("app.use_without_mail_account", true);
/* 0373: disable warning when customizing "From address" ***/
   // user_pref("mail.compose.warned_about_customize_from", true);
/* 0374: prevent donation appeal page opening on fresh profiles
 * $url Web page is opened if $viewed is lower than $version (and 0330 policy bypass notification is disabled)
 * [1] https://searchfox.org/comm-esr115/source/mail/base/content/messenger.js#455 ***/
   // user_pref("app.donation.eoy.version", 2);
user_pref("app.donation.eoy.version.viewed", 999);
   // user_pref("app.donation.eoy.url", "https://www.thunderbird.net/thunderbird/115.0/appeal/");
/* 0380: disable the new/unread message count badge on taskbar icon
 * [1] https://www.thunderbird.net/en-US/thunderbird/91.0.2/releasenotes/#whatsnew */
  // user_pref("mail.biff.show_badge", false); // [WINDOWS]
/* 0381: show the number of "new" messages on taskbar icon (not the number of unread ones) ***/
  // user_pref("mail.biff.use_new_count_in_badge", true);
/* 0390: disable new email alerts
 * [SETTING] General > Incoming Mails > When new messages arrive > Show an alert ***/
   // user_pref("mail.biff.show_alert", false);
/* 0391: control the kind of information disclosed in new email alerts
 * These preferences MAY be appreciated in environments with inquisitive eyes wandering behind your screen.
 * [SETTING] General > Incoming Mails > When new messages arrive > Show an alert > Customize... ***/
   // user_pref("mail.biff.alert.show_preview", false);
   // user_pref("mail.biff.alert.show_subject", false);
   // user_pref("mail.biff.alert.show_sender", false);
   // user_pref("mail.biff.alert.preview_length", 40);  // [HIDDEN PREF]
