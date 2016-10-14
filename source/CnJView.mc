using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;

class CnJView extends Ui.WatchFace {

	var cnjBG;
	var showOther = false;
	var secString = "";
	var batString = "";
	var dateString = "";
	var monthString = "";

    function initialize() {
        WatchFace.initialize();
		cnjBG = new Ui.Bitmap({:rezId=>Rez.Drawables.cnj});
    }

	function onLayout(dc) {
    }

    function onUpdate(dc) {
		View.onUpdate(dc);

		//pull data from Garmin Connect/storage
		var app = App.getApp();

		var  numColor = app.getProperty("num_prop");
		if (numColor == null) {
			numColor = Gfx.COLOR_BLACK;
		}

		var bowColor = app.getProperty("bow_prop");
		if (bowColor == null) {
			bowColor = Gfx.COLOR_DK_RED;
		}

		var bgColor = app.getProperty("bg_prop");
		if (bgColor == null) {
			bgColor = Gfx.COLOR_WHITE;
		}

		//get watch time
		var clockTime = Sys.getClockTime();
		var timeString = Lang.format("$1$$2$",[clockTime.hour, clockTime.min.format("%02d")]); //hhmm


		// color background
		dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		// color bowtie
		dc.setColor(bowColor, Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(125, 145, 65, 45);

		// draw faces
	    cnjBG.draw(dc);

		if (showOther) {
			//retrieve time & date
			secString = clockTime.sec;
			secString = Lang.format("$1$",[secString]);

			var sysStats = Sys.getSystemStats();

			var now = Time.now();
			var info = Calendar.info(now, Time.FORMAT_LONG);
			monthString = Lang.format("$1$", [info.month]);
			dateString = Lang.format("$1$", [info.day]);

			//retrieve battery data
			var batWidth = 0;
			var batColor = Gfx.COLOR_DK_GRAY;
			var batOutline = Gfx.COLOR_WHITE;

			var battery = sysStats.battery;
			batString = Lang.format("$1$",[battery.format("%01.0i")]) + '%';
			batWidth = 10 - (battery / 10) + 7;
			if (battery >= 50) {
				batColor = Gfx.COLOR_DK_GREEN;
			}
			else if (battery >= 20) {
				batColor = Gfx.COLOR_YELLOW;
			}
			else {
				batColor = Gfx.COLOR_DK_RED;
			}

			//draw battery icon as a series of overlapping rectangles

			//make it visibile if the BG color is the white
			if (bgColor == Gfx.COLOR_WHITE) {
				batOutline = Gfx.COLOR_DK_GRAY;
			}
			else {
				batOutline = Gfx.COLOR_WHITE;
			}

			dc.setPenWidth(10);
			dc.setColor(batOutline, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(6, 104, 20, 104);

			dc.setPenWidth(8);
	    	dc.drawLine(4, 104, 6, 104);

			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(7, 104, 19, 104);

			dc.setColor(batColor, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(18, 104, batWidth, 104);
		}

		//set font color to selected from Garmin Connect/storage
		dc.setColor(numColor, Gfx.COLOR_TRANSPARENT);

		// time
		dc.drawText(90, 18, Gfx.FONT_NUMBER_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_RIGHT);

		// seconds
		dc.drawText(190, 86, Gfx.FONT_MEDIUM, secString, Gfx.TEXT_JUSTIFY_LEFT);

		// date
		dc.drawText(99, 10, Gfx.FONT_SYSTEM_TINY, dateString, Gfx.TEXT_JUSTIFY_RIGHT);

		// calendar month
		dc.drawText(72, 10, Gfx.FONT_SYSTEM_TINY, monthString, Gfx.TEXT_JUSTIFY_RIGHT);

		// battery percentage
		dc.drawText(29, 80, Gfx.FONT_SYSTEM_XTINY, batString, Gfx.TEXT_JUSTIFY_RIGHT);
    }

	function onExitSleep() {
		showOther = true;
	}

	function onEnterSleep() {
		clearData();
		Ui.requestUpdate();
	}

	function clearData() {
		secString = "";
		batString = "";
		dateString = "";
		monthString = "";
		showOther = false;
		return true;
	}
}