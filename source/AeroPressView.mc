import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class AeroPressView extends WatchUi.View {
  private var _taskElement;
  private var _timerElement;
  private var _completeElement;
  private var _arcValue;
  private var _isComplete;

  function initialize() {
    View.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.MainLayout(dc));

    _taskElement = findDrawableById("task");
    _timerElement = findDrawableById("timer");
    _completeElement = findDrawableById("complete");
    _arcValue = 0;
    _isComplete = false;
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    _completeElement.setVisible(false);
    // setTaskValue("Ready to Brew?");
    // setTimerValue(90);
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
    // System.println("here");
    // System.println(_arcValue);
    if (!_isComplete) {
      dc.setPenWidth(10);
      dc.drawArc(
        dc.getWidth() / 2,
        dc.getHeight() / 2,
        dc.getHeight() / 2,
        Graphics.ARC_CLOCKWISE,
        90,
        90 + _arcValue
      );
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  function setTaskValue(value as String) as Void {
    _taskElement.setText(value);

    WatchUi.requestUpdate();
  }

  function setTimerValue(value as Number) as Void {
    var current = formatTime(value / 60, value % 60);

    _timerElement.setText(current);

    WatchUi.requestUpdate();
  }

  function setArcData(value as Number) as Void {
    _arcValue = value;
  }

  function setIsCompleted(isComplete as Boolean) as Void {
    _timerElement.setVisible(!isComplete);
    _taskElement.setVisible(!isComplete);
    _completeElement.setVisible(isComplete);
    _isComplete = isComplete;
  }

  private function formatTime(minutes as Number, seconds as Number) as String {
    var secondsFormatted =
      seconds > 9 ? seconds.toString() : "0" + seconds.toString();
    return minutes.toString() + ":" + secondsFormatted;
  }
}
