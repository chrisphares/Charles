using Toybox.Application as App;
using Toybox.WatchUi as Ui;

var cnjFont;
var numberColor;
var bowtieColor;

class CnJApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [new CnJView(), new Ui.BehaviorDelegate()];
    }
}