using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;

class CnJView extends Ui.WatchFace {

	var cnjBG;
	var cnjFont;
	var cnjBGFont;
	var showOther = false;
	var secString = "";
	var batString = "";
	var date = "";
	var month = "";
	var batColor = Gfx.COLOR_WHITE;
	var batWidth = 0;

    function initialize() {
        WatchFace.initialize();
		cnjBG = new Ui.Bitmap({:rezId=>Rez.Drawables.cnj});
		cnjFont = Ui.loadResource(Rez.Fonts.bowtie_fnt);
		cnjBGFont = Ui.loadResource(Rez.Fonts.cnjBG_fnt);
    }

	function onLayout(dc) {
    }

    function onUpdate(dc) {
		View.onUpdate(dc);

		var clockTime = Sys.getClockTime();

		var hourString = clockTime.hour;
		hourString = Lang.format("$1$",[hourString]);

		var minString = clockTime.min;
		minString = Lang.format("$1$",[minString.format("%02d")]);

		// draw faces
	    cnjBG.draw(dc);

		// draw bowtie
	    dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
	    dc.drawText(0, -1, cnjFont, "B", Gfx.TEXT_JUSTIFY_LEFT);

		// draw background
	    dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_LT_GRAY);
	    dc.drawText(0, -1, cnjBGFont, "A", Gfx.TEXT_JUSTIFY_LEFT);

		if (showOther) {
			secString = clockTime.sec;
			secString = Lang.format("$1$",[secString]);

			var sysStats = Sys.getSystemStats();

			var now = Time.now();
			var info = Calendar.info(now, Time.FORMAT_LONG);
			month = Lang.format("$1$", [info.month]);
			date = Lang.format("$1$", [info.day]);

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
			dc.setPenWidth(10);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(6, 104, 20, 104);

			dc.setPenWidth(8);
	    	dc.drawLine(4, 104, 6, 104);

			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(7, 104, 19, 104);

			dc.setColor(batColor, Gfx.COLOR_TRANSPARENT);
	    	dc.drawLine(18, 104, batWidth, 104);
		}

		// hours
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.drawText(59, 18, Gfx.FONT_NUMBER_MEDIUM, hourString, Gfx.TEXT_JUSTIFY_RIGHT);

		// minutes
		dc.drawText(61, 18, Gfx.FONT_NUMBER_MEDIUM, minString, Gfx.TEXT_JUSTIFY_LEFT);

		// seconds
		dc.drawText(190, 86, Gfx.FONT_MEDIUM, secString, Gfx.TEXT_JUSTIFY_LEFT);

		// date
		dc.drawText(99, 10, Gfx.FONT_SYSTEM_TINY, date, Gfx.TEXT_JUSTIFY_RIGHT);

		// calendare month
		dc.drawText(72, 10, Gfx.FONT_SYSTEM_TINY, month, Gfx.TEXT_JUSTIFY_RIGHT);

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
		date = "";
		month = "";
		showOther = false;
		return true;
	}
}