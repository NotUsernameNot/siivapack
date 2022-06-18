package ui;

import openfl.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import haxe.ds.StringMap;

class Performance extends Page
{
	public static var performance:StringMap<Dynamic> = new StringMap<Dynamic>();

	var checkboxes:Array<CheckboxThingie> = [];
	var menuCamera:FlxCamera;
	var items:TextMenuList;
	var camFollow:FlxObject;

	override public function new()
	{
		super();
		menuCamera = new FlxCamera();
		FlxG.cameras.add(menuCamera, false);
		menuCamera.bgColor = FlxColor.TRANSPARENT;
		camera = menuCamera;
		add(items = new TextMenuList());
		createPrefItem('Low Quality Stages', 'low-stage', false);
		createPrefItem('Low Quality BF', 'low-bf', false);
		createPrefItem('Low Quality GF', 'low-gf', true);
		createPrefItem('Low Quality Opponent', 'low-dad', false);
		createPrefItem('Pixel UI', 'pixel-ui', false);
		camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
		if (items != null)
		{
			camFollow.y = items.members[items.selectedIndex].y;
		}
		menuCamera.follow(camFollow, null, 0.06);
		menuCamera.deadzone.set(0, 160, menuCamera.width, 40);
		menuCamera.minScrollY = 0;
		items.onChange.add(function(item:TextMenuItem)
		{
			camFollow.y = item.y;
		});
	}

	public static function getPref(pref:String)
	{
		return performance.get(pref);
	}

	public static function initPrefs()
	{
		preferenceCheck('low-stage', true);
		preferenceCheck('low-bf', true);
		preferenceCheck('low-gf', false);
		preferenceCheck('low-dad', true);
		preferenceCheck('pixel-ui', true);
	}

	public static function preferenceCheck(identifier:String, defaultValue:Dynamic)
	{
		if (performance.get(identifier) == null)
		{
			performance.set(identifier, defaultValue);
			trace('set performance!');
		}
		else
		{
			trace('found performance: ' + Std.string(performance.get(identifier)));
		}
	}

	public function createPrefItem(label:String, identifier:String, value:Dynamic)
	{
		items.createItem(120, 120 * items.length + 30, label, Bold, function()
		{
			preferenceCheck(identifier, value);
			if (Type.typeof(value) == TBool)
			{
				prefToggle(identifier);
			}
			else
			{
				trace('swag');
			}
		});
		if (Type.typeof(value) == TBool)
		{
			createCheckbox(identifier);
		}
		else
		{
			trace('swag');
		}
		trace(Type.typeof(value));
	}

	public function createCheckbox(identifier:String)
	{
		var box:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), performance.get(identifier));
		checkboxes.push(box);
		add(box);
	}

	public function prefToggle(identifier:String)
	{
		var value:Bool = performance.get(identifier);
		value = !value;
		performance.set(identifier, value);
		checkboxes[items.selectedIndex].daValue = value;
		trace('toggled? ' + Std.string(performance.get(identifier)));
		switch (identifier)
		{
			case 'auto-pause':
				FlxG.autoPause = getPref('auto-pause');
			case 'fps-counter':
				if (getPref('fps-counter'))
					Lib.current.stage.addChild(Main.fpsCounter);
				else
					Lib.current.stage.removeChild(Main.fpsCounter);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
		items.forEach(function(item:MenuItem)
		{
			if (item == items.members[items.selectedIndex])
				item.x = 150;
			else
				item.x = 120;
		});
	}
}