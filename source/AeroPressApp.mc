import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AeroPressApp extends Application.AppBase {
  private var _view;

  function initialize() {
    AppBase.initialize();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {}

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {}

  // Return the initial view of your application here
  function getInitialView() as Array<Views or InputDelegates>? {
    _view = new AeroPressView();
    return [_view, new AeroPressDelegate()] as Array<Views or InputDelegates>;
  }

  function getView() as AeroPressView {
    return _view;
  }
}

function getApp() as AeroPressApp {
  return Application.getApp() as AeroPressApp;
}

function getView() as AeroPressView {
  return Application.getApp().getView();
}
