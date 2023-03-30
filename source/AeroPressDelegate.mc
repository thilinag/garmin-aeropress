import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;
import Toybox.Timer;

class AeroPressDelegate extends WatchUi.BehaviorDelegate {
  private var _view as AeroPressView = getView();
  private var _timer;
  private var _brewing as Boolean = false;

  private var steps as Array<Step> = [
    new Step("Brewing", 110),
    new Step("Stir", 10),
    new Step("Let sit", 30),
    new Step("Press", 30),
  ];

  private var _totalDuration as Number = 0;
  private var _currentDuration as Number = 0;
  private var _currentStep as Number = 0;

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() as Boolean {
    if (!_brewing) {
      _brewing = true;
      startCountdown();
    }
    return true;
  }

  function onNextPage() {
    if (!_brewing) {
      return false;
    }

    callAttention();
    _timer.stop();
    _brewing = false;
    _totalDuration = 0;
    _currentDuration = 0;
    _currentStep = 0;
    _view.setTimerValue(steps[0].duration);
    _view.setTaskValue(steps[0].label);
    _view.setArcData(0);
    return true;
  }

  private function startCountdown() as Void {
    _totalDuration = 0;
    for (var i = 0; i < steps.size(); i++) {
      _totalDuration += steps[i].duration;
    }

    _currentStep = 0;
    _currentDuration = steps[0].duration - 1;
    _totalDuration--;

    _view.setIsCompleted(false);

    callAttention();
    _timer = new Timer.Timer();
    _timer.start(method(:updateCountdownValue), 1000, true);
  }

  function updateCountdownValue() as Void {
    if (_totalDuration == 0) {
      callAttention();
      _view.setTimerValue(0);
      _view.setArcData(0);
      _timer.stop();
      _brewing = false;
      _view.setIsCompleted(true);
      return;
    }

    if (_currentDuration == 0) {
      _currentStep++;
      callAttention();
      _view.setTaskValue(steps[_currentStep].label);
      _currentDuration = steps[_currentStep].duration;
    }

    _view.setTaskValue(steps[_currentStep].label);
    _view.setTimerValue(_currentDuration);
    _view.setArcData(
      (
        (_currentDuration.toFloat() / steps[_currentStep].duration) *
        360
      ).toNumber()
    );

    _totalDuration--;
    _currentDuration--;
  }

  function callAttention() as Void {
    if (_currentStep > 0) {
      var vibeData = [new Attention.VibeProfile(100, 500)];
      Attention.vibrate(vibeData);
    }
    Attention.backlight(true);

    (new Timer.Timer()).start(method(:turnOffBacklight), 3000, false);
  }

  function turnOffBacklight() as Void {
    Attention.backlight(false);
  }
}
