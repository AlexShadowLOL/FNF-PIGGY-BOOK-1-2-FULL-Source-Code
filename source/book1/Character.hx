package book1;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var noteSkin:String = 'normal';
	public var camOffset:Array<Float> = [0, 0];
	
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'bf':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/Player_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle instance', 24, false);
				animation.addByPrefix('singUP', 'Player Up instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right instance 1', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHT', 'Player Left instance 1', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWN', 'Player Down instance 1', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss instance', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss instance', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss instance', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true; // you fucking suck

				trace("Player Added Sucessfully.");	

			case 'bfpiracy':
				noteSkin = 'neonblack';
				var tex = Paths.getSparrowAtlas('characters/book1/PlayerPIRACY_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle instance', 24, false);
				animation.addByPrefix('singUP', 'Player Up instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right instance 1', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHT', 'Player Left instance 1', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWN', 'Player Down instance 1', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss instance', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss instance', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss instance', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true; // you fucking suck

				trace("Player PIRACY Added Sucessfully.");	

			case 'pennynormal':
				noteSkin = 'penny';
				tex = Paths.getSparrowAtlas('characters/book1/Penny_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Penny Idle', 24);
				animation.addByPrefix('singUP', 'Penny Up', 24);
				animation.addByPrefix('singRIGHT', 'Penny Right', 24);
				animation.addByPrefix('singDOWN', 'Penny Down', 24);
				animation.addByPrefix('singLEFT', 'Penny Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Penny Added Sucessfully.");	

			case 'nmpenny':
				noteSkin = 'neonblack';
				tex = Paths.getSparrowAtlas('characters/book1/Nightmare_Penny_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Penny Idle', 24);
				animation.addByPrefix('singUP', 'Penny Up', 24);
				animation.addByPrefix('singRIGHT', 'Penny Right', 24);
				animation.addByPrefix('singDOWN', 'Penny Down', 24);
				animation.addByPrefix('singLEFT', 'Penny Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Nightmare Penny Added Sucessfully.");

			case 'nmwillow':
				noteSkin = 'neonblack';
				tex = Paths.getSparrowAtlas('characters/book1/Nightmare_Willow_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Willow Idle', 24);
				animation.addByPrefix('singUP', 'Willow Up', 24);
				animation.addByPrefix('singRIGHT', 'Willow Right', 24);
				animation.addByPrefix('singDOWN', 'Willow Down', 24);
				animation.addByPrefix('singLEFT', 'Willow Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Nightmare Willow Added Sucessfully.");
		}

		dance();

		if (isPlayer)
		{
		    flipX = !flipX;
			
			// Doesn't flip for Player, since their sprites are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				// trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/book1/' + character + "offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
