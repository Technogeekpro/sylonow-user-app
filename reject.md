Guideline 4.8 - Design - Login Services


The app uses a third-party login service, but does not appear to offer as an equivalent login option another login service with all of the following features:

- The login option limits data collection to the user’s name and email address.
- The login option allows users to keep their email address private from all parties as part of setting up their account.
- The login option does not collect interactions with the app for advertising purposes without consent. 

Next Steps

Revise the app to offer as an equivalent login option another login service that meets all of the above requirements.

If the app already includes another login service that meets all of the above requirements, reply to App Review in App Store Connect, identify which login service meets all of the requirements, and explain why it meets all of the requirements.

Note that Sign in with Apple is a login service meets all the requirements specified in guideline 4.8.

Additionally, it would be appropriate to update the screenshots in the app's metadata to accurately reflect the revised app once another login service has been implemented.

Resources

Learn about the benefits of Sign in with Apple.


Guideline 5.1.2 - Legal - Privacy - Data Use and Sharing


The app privacy information provided in App Store Connect indicates the app collects data in order to track the user, including Phone Number and Physical Address. However, the app does not use App Tracking Transparency to request the user's permission before tracking their activity.

Apps need to receive the user’s permission through the AppTrackingTransparency framework before collecting data used to track them. This requirement protects the privacy of users.

Next Steps

Here are three ways to resolve this issue:

- If the app does not currently track, update the app privacy information in App Store Connect. You must have the Account Holder or Admin role to update app privacy information. If you are unable to change the privacy label, reply to this message in App Store Connect, and make sure your App Privacy Information in App Store Connect is up to date before submitting your next update for review.

- If this app does not track on the platform associated with this submission, but tracks on other platforms, notify App Review by replying to the rejection in App Store Connect. You should also reply if this app does not track on the platform associated with this submission but tracks on other Apple platforms this app is available on.

- If the app tracks users on all supported platforms, the app must use App Tracking Transparency to request permission before collecting data used to track. When resubmitting, indicate in the Review Notes where the permission request is located.

Note that if the app behaves differently in different countries or regions, you should provide a way for App Review to review these variations in the app submission. Additionally, these differences should be documented in the Review Notes section of App Store Connect.

Resources

- Tracking is linking data collected from the app with third-party data for advertising purposes, or sharing the collected data with a data broker. Learn more about tracking. 
- See Frequently Asked Questions about the requirements for apps that track users.
- Learn more about designing appropriate permission requests.


Guideline 2.1 - Performance - App Completeness

Issue Description

The app exhibited one or more bugs that would negatively impact users.

Bug description: an error message displayed when we tried to login with demo account. 

Review device details:

- Device type: iPad Air (5th generation) 
- OS version: iPadOS 26.0

Next Steps

Test the app on supported devices to identify and resolve bugs and stability issues before submitting for review.

If the bug cannot be reproduced, try the following:

- For new apps, uninstall all previous versions of the app from a device, then install and follow the steps to reproduce.
- For app updates, install the new version as an update to the previous version, then follow the steps to reproduce.

Resources

- For information about testing apps and preparing them for review, see Testing a Release Build.
- To learn about troubleshooting networking issues, see Networking Overview.



Guideline 2.1 - Information Needed


We are unable to successfully access all or part of the app. In order to continue the review, we need to have a way to verify all app features and functionality for all account types. Typically this is done by providing a demo account that has access to all features and functionality in the app.

Next Steps

To resolve this issue, provide a user name and password in the App Review Information section of App Store Connect. It is also acceptable to include a demonstration mode that exhibits the app’s full features and functionality. Note that providing a demo video showing the app in use is not sufficient to continue the review.

Resources

To learn more about providing information in App Store Connect, see App Store Connect Help.

Support

- Reply to this message in your preferred language if you need assistance. If you need additional support, use the Contact Us module.
- Consult with fellow developers and Apple engineers on the Apple Developer Forums.
- Request an App Review Appointment at Meet with Apple to discuss your app's review. Appointments subject to availability during your local business hours on Tuesdays and Thursdays.
- Provide feedback on this message and your review experience by completing a short survey.
Request a phone call from App Review

At your request, we can arrange for an Apple Representative to call you within the next three to five business days to discuss your App Review issue.

Request a call to discuss your app's review