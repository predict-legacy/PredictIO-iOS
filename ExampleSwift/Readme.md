## Overview
The Example project shows how the predict.io SDK works and also how the predict.io SDK should be integrated into your App. This example App list all events received from the predict.io SDK and can be used to test and verify the SDK performance and accuracy.

## User interface
![](https://www.predict.io/wp-content/uploads/Home_UI_guide-1.png)

The Sample app has two tabs named "Delegate" and "Notifications". In the delegate tab the event data is received using a delegate (you should implement `PredictIODelegate` protocol.

In the notification tab the event data is received via notifications, which are broadcasted by the SDK using `NSNotificationCenter` API.

Once you've done a test trip you'll see a list of events detected by the SDK. Tapping on a cell will show you more details about the event.

![](https://www.predict.io/wp-content/uploads/location-and-accuracy-view-1.png)

## Running and Testing
*Before you build and run the Example projects, make sure you set your API key in PredictIOService class.*

On the first launch of the Example App you will see an empty table view, on top-right corner tap the `Start` button to activate the SDK. The SDK will verify your API key and then will start collecting data.

There are two possibilities to test the predict.io Example App

* Using iOS Simulator

* Using iOS device

  *We recommend you test the Example App in the Simulator first before taking a test trip on a real device.*
### Using iOS Simulator

![](https://www.predict.io/wp-content/uploads/Screen-Shot-2016-10-06-at-8.27.24-PM.png)

When you run Example App on the Simulator, go to the menu bar. Select Debug > Location > Freeway Drive. By doing this you can simulate real time GPS data that is received when user in driving some vehicle on a high way, you should see the departure event on the App in about a minute.

If you want to get the arrival event go to menu bar click Debug > Location > Apple, you should get arrival event shortly after predict.io validates your trip i.e. distance travelled and duration.

### Using iOS Device
Start the Example App on your iPhone, put it in your pocket or place at the dashboard. Get to your vehicle and start driving, you should get the departure event on the App in few minutes. Just drive around and then park your vehicle. After predict.io validates your trip i.e. distance travelled and duration, it will send you an arrival event.
