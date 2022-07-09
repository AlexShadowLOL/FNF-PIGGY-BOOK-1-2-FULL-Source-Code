package;

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

			case 'bfstore': // same character with no animations changes, but the guy is more darker cuz store bg shading
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerSTORE_assets', 'shared');
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

				trace("Player (Store Ver.) Added Sucessfully.");	

			case 'bfrefinery': // same character with no animations changes, but the guy is more darker cuz refinery bg shading x2
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerREFINERY_assets', 'shared');
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

				trace("Player (Refinery Ver.) Added Sucessfully.");	

			case 'bfsewers': // same character with no animations changes, but the guy is more darker cuz ship bg shading x3
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerSEWERS_assets', 'shared');
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

				trace("Player (Sewers Ver.) Added Sucessfully.");	

			case 'bfship': // same character with no animations changes, but the guy is more darker cuz ship bg shading x3
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerSHIP_assets', 'shared');
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

				trace("Player (Ship Ver.) Added Sucessfully.");	

			case 'bfdocks': // same character with no animations changes, but the guy is more darker cuz docks bg shading x4
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerDOCKS_assets', 'shared');
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

				trace("Player (Docks Ver.) Added Sucessfully.");	

			case 'bfcamp': // same character with no animations changes, but the guy is more darker cuz camp bg shading x5
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerCAMP_assets', 'shared');
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

				trace("Player (Camp Ver.) Added Sucessfully.");	

			case 'bfwinter': // same character with no animations changes, but the guy is more darker cuz camp bg shading x5
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerCAMP_assets', 'shared');
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

				trace("Player (Winter Ver.) Added Sucessfully.");	

			// why this sounds so racist lmfao
			case 'bfwhite': // same character with no animations changes, but the guy is more white cuz yes
			    noteSkin = 'white';
				var tex = Paths.getSparrowAtlas('characters/Player_WHITE_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
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

				trace("Player (White Ver.) Added Sucessfully.");	

			case 'bfperspective': // same character with no animations changes (idfk), but the guy is in another perspective
			    noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/PlayerPERSPECTIVE_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Player Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Left miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Player Right miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Player Down miss', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
				
				flipX = true; // you fucking suck x7

				trace("Player (Different Perspective Ver.) Added Sucessfully.");	

			case 'zuzyholiday': // finally a new player, im already tired of the shitty grey guy :ng_sad:
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/ZuzyWINTERHOLIDAY_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Zuzy Idle', 24, false);
				animation.addByPrefix('singUP', 'Zuzy Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Zuzy Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Zuzy Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Zuzy Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Zuzy Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Zuzy Left Miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Zuzy Right Miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Zuzy Down Miss', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true; // you fucking suck x7

				trace("Zuzy (Winter Holiday ver.) Added Sucessfully.");

			case 'ponyheist':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/Pony_Heist_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Pony Idle', 24, false);
				animation.addByPrefix('singUP', 'Pony Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Pony Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pony Left0', 24, false);
				animation.addByPrefix('singDOWN', 'Pony Down0', 24, false);

				animation.addByPrefix('singUPmiss', 'Pony Idle', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pony Idle', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pony Idle', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pony Idle', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true; // you fucking suck x7

				trace("Pony (Heist ver.) Added Sucessfully.");

		    case 'zizzy':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/Zizzy_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Zizzy Idle', 24, false);
				animation.addByPrefix('singUP', 'Zizzy Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Zizzy Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Zizzy Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Zizzy Down0', 24, false);

				animation.addByPrefix('singUPmiss', 'Missing Deez Nuts', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Missing Deez Nuts', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Missing Deez Nuts', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Missing Deez Nuts', 24, false);

				animation.addByPrefix('ending', "Zizzy Ending", 24, false);

				addOffset('idle');
				addOffset("singUP", -25, 13);
				addOffset("singRIGHT", -1, -2);
				addOffset("singLEFT", -42, -10);
				addOffset("singDOWN", -29, -12);

				addOffset("singUPmiss", -11, 2);
				addOffset("singRIGHTmiss", -11, 2);
				addOffset("singLEFTmiss", -11, 2);
				addOffset("singDOWNmiss", -11, 2);

				addOffset('ending', -11, 1);
 
				loadOffsetFile(curCharacter);

				playAnim('idle');
				
				// flipX = true; // you fucking suck x7

				trace("Zizzy Added Sucessfully.");

			case 'tigrymilitar':
				noteSkin = 'neonblack';
				var tex = Paths.getSparrowAtlas('characters/Breakout_Tigry_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Tigry Idle', 24, false);
				animation.addByPrefix('singUP', 'Tigry Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Tigry Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHT', 'Tigry Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWN', 'Tigry Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Tigry Idle', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Tigry Idle', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHTmiss', 'Tigry Idle', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWNmiss', 'Tigry Idle', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 7, 34);
				addOffset("singRIGHT", 4, -6);
				addOffset("singLEFT", 59, -8);
				addOffset("singDOWN", 98, -156);
				addOffset("singUPmiss", 0, 0);
				addOffset("singRIGHTmiss", 0, 0);
				addOffset("singLEFTmiss", 0, 0);
				addOffset("singDOWNmiss", 0, 0);

				playAnim('idle');

				flipX = true; // you fucking suck

				trace("Tigry Militar Added Sucessfully.");	

			case 'rash':
				noteSkin = 'rash';
				tex = Paths.getSparrowAtlas('characters/Rash_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Rash Idle', 24);
				animation.addByPrefix('singUP', 'Rash Up', 24);
				animation.addByPrefix('singRIGHT', 'Rash Right', 24);
				animation.addByPrefix('singDOWN', 'Rash Down', 24);
				animation.addByPrefix('singLEFT', 'Rash Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');		
				
				trace("Rash Added Sucessfully.");
					
			case 'dessa':
				noteSkin = 'dessa';
				tex = Paths.getSparrowAtlas('characters/Dessa_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dessa Idle', 24);
				animation.addByPrefix('singUP', 'Dessa Up', 24);
				animation.addByPrefix('singRIGHT', 'Dessa Right', 24);
				animation.addByPrefix('singDOWN', 'Dessa Down', 24);
				animation.addByPrefix('singLEFT', 'Dessa Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');		
				
				trace("Dessa Added Sucessfully.");	

			case 'tigry':
				noteSkin = 'tigry';
				tex = Paths.getSparrowAtlas('characters/Tigry_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tigry Idle', 24);
				animation.addByPrefix('singUP', 'Tigry Up', 24);
				animation.addByPrefix('singRIGHT', 'Tigry Right', 24);
				animation.addByPrefix('singDOWN', 'Tigry Down', 24);
				animation.addByPrefix('singLEFT', 'Tigry Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	
				
				trace("Tigry Added Sucessfully.");	

			case 'raze':
				noteSkin = 'raze';
				tex = Paths.getSparrowAtlas('characters/Raze_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Raze Idle', 24);
				animation.addByPrefix('singUP', 'Raze Up', 24);
				animation.addByPrefix('singRIGHT', 'Raze Right', 24);
				animation.addByPrefix('singDOWN', 'Raze Down', 24);
				animation.addByPrefix('singLEFT', 'Raze Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Raze Added Sucessfully.");	
			
			case 'alfis':
				noteSkin = 'alfis';
				tex = Paths.getSparrowAtlas('characters/Alfis_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Alfis Idle', 24);
				animation.addByPrefix('singUP', 'Alfis Up', 24);
				animation.addByPrefix('singRIGHT', 'Alfis Right', 24);
				animation.addByPrefix('singDOWN', 'Alfis Down', 24);
				animation.addByPrefix('singLEFT', 'Alfis Left', 24);

				loadOffsetFile(curCharacter);
				
				playAnim('idle');	

				trace("Alfis Added Sucessfully.");	
				
			case 'willow': // the lesbian bitch
			    noteSkin = 'purple';
				tex = Paths.getSparrowAtlas('characters/Willow_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Willow Idle', 24);
				animation.addByPrefix('singUP', 'Willow Up', 24);
				animation.addByPrefix('singRIGHT', 'Willow Right', 24);
				animation.addByPrefix('singDOWN', 'Willow Down', 24);
				animation.addByPrefix('singLEFT', 'Willow Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Willow Added Sucessfully.");	

			case 'dakoda':
				noteSkin = 'dakoda';
				tex = Paths.getSparrowAtlas('characters/Dakoda_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dakoda Idle', 24);
				animation.addByPrefix('singUP', 'Dakoda Up', 24);
				animation.addByPrefix('singRIGHT', 'Dakoda Right', 24);
				animation.addByPrefix('singDOWN', 'Dakoda Down', 24);
				animation.addByPrefix('singLEFT', 'Dakoda Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Dakoda Added Sucessfully.");		

			case 'archie':
				noteSkin = 'archie';
				tex = Paths.getSparrowAtlas('characters/Archie_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Archie Idle', 24);
				animation.addByPrefix('singUP', 'Archie Up', 24);
				animation.addByPrefix('singRIGHT', 'Archie Right', 24);
				animation.addByPrefix('singDOWN', 'Archie Down', 24);
				animation.addByPrefix('singLEFT', 'Archie Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Archie Added Sucessfully.");		
				
			case 'markus':
				noteSkin = 'markus';
				tex = Paths.getSparrowAtlas('characters/Markus_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Markus Idle', 24);
				animation.addByPrefix('singUP', 'Markus Up', 24);
				animation.addByPrefix('singRIGHT', 'Markus Right', 24);
				animation.addByPrefix('singDOWN', 'Markus Down', 24);
				animation.addByPrefix('singLEFT', 'Markus Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Markus Added Sucessfully.");	

			case 'spidella':
				noteSkin = 'spidella';
				tex = Paths.getSparrowAtlas('characters/Spidella_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Spidella Idle', 24);
				animation.addByPrefix('singUP', 'Spidella Up', 24);
				animation.addByPrefix('singRIGHT', 'Spidella Right', 24);
				animation.addByPrefix('singDOWN', 'Spidella Down', 24);
				animation.addByPrefix('singLEFT', 'Spidella Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Spidella Added Sucessfully.");	

			case 'delta':
				noteSkin = 'delta';
				tex = Paths.getSparrowAtlas('characters/Delta_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Delta Idle', 24);
				animation.addByPrefix('singUP', 'Delta Up', 24);
				animation.addByPrefix('singRIGHT', 'Delta Right', 24);
				animation.addByPrefix('singDOWN', 'Delta Down', 24);
				animation.addByPrefix('singLEFT', 'Delta Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Delta Added Sucessfully.");

			case 'penny':
				noteSkin = 'penny';
				tex = Paths.getSparrowAtlas('characters/Penny_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Penny Idle instance', 24);
				animation.addByPrefix('singUP', 'Penny Up instance', 24);
				animation.addByPrefix('singRIGHT', 'Penny Right instance', 24);
				animation.addByPrefix('singDOWN', 'Penny Down instance', 24);
				animation.addByPrefix('singLEFT', 'Penny Left instance', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Penny Added Sucessfully.");	

			case 'zizzyholiday':
				noteSkin = 'zizzyholiday';
				tex = Paths.getSparrowAtlas('characters/ZizzyWINTERHOLIDAY_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Zizzy Idle instance', 24);
				animation.addByPrefix('singUP', 'Zizzy Up instance', 24);
				animation.addByPrefix('singRIGHT', 'Zizzy Right instance', 24);
				animation.addByPrefix('singDOWN', 'Zizzy Down instance', 24);
				animation.addByPrefix('singLEFT', 'Zizzy Left instance', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Zizzy (Winter Holiday ver.) Added Sucessfully.");	

			case 'willowstore': // the lesbian bitch
			    noteSkin = 'purple';
				tex = Paths.getSparrowAtlas('characters/Willow_STORE_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Willow Idle', 24);
				animation.addByPrefix('singUP', 'Willow Up', 24);
				animation.addByPrefix('singRIGHT', 'Willow Right', 24);
				animation.addByPrefix('singDOWN', 'Willow Down', 24);
				animation.addByPrefix('singLEFT', 'Willow Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Willow Added Sucessfully.");	

			case 'willowwhite': // the lesbian bitch
			    noteSkin = 'white';
				tex = Paths.getSparrowAtlas('characters/Willow_WHITE_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Willow Idle', 24);
				animation.addByPrefix('singUP', 'Willow Up', 24);
				animation.addByPrefix('singRIGHT', 'Willow Right', 24);
				animation.addByPrefix('singDOWN', 'Willow Down', 24);
				animation.addByPrefix('singLEFT', 'Willow Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Willow Added Sucessfully.");	

			case 'kolie': // coal
			    noteSkin = 'bf';
				tex = Paths.getSparrowAtlas('characters/Kolie_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Kolie Idle', 24);
				animation.addByPrefix('singUP', 'Kolie Up', 24);
				animation.addByPrefix('singRIGHT', 'Kolie Right', 24);
				animation.addByPrefix('singDOWN', 'Kolie Down', 24);
				animation.addByPrefix('singLEFT', 'Kolie Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Kolie Added Sucessfully.");	

			case 'tigrymad': // u mad bro? u mad?
			    noteSkin = 'tigry';
				tex = Paths.getSparrowAtlas('characters/Tigry_MAD_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tigry Idle', 24);
				animation.addByPrefix('singUP', 'Tigry Up', 24);
				animation.addByPrefix('singRIGHT', 'Tigry Right', 24);
				animation.addByPrefix('singDOWN', 'Tigry Down', 24);
				animation.addByPrefix('singLEFT', 'Tigry Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Tigry Added Sucessfully.");	

			case 'tigrydark': // why he bla-
			    noteSkin = 'tigry';
				tex = Paths.getSparrowAtlas('characters/Tigry_DARK_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tigry Idle', 24);
				animation.addByPrefix('singUP', 'Tigry Up', 24);
				animation.addByPrefix('singRIGHT', 'Tigry Right', 24);
				animation.addByPrefix('singDOWN', 'Tigry Down', 24);
				animation.addByPrefix('singLEFT', 'Tigry Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Tigry DARK Added Sucessfully.");	

			case 'felixdumb':
				noteSkin = 'felix';
				tex = Paths.getSparrowAtlas('characters/FelixDumb_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Felix Idle', 24, false);
				animation.addByPrefix('singUP', 'Felix Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Felix Right', 24, false);
				animation.addByPrefix('singLEFT', 'Felix Left', 24, false);
				animation.addByPrefix('singDOWN', 'Felix Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("Felix Dumb Added Sucessfully.");

			case 'frostiggy':
				noteSkin = 'frostiggy';
				tex = Paths.getSparrowAtlas('characters/Frostiggy_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Frostiggy Idle', 24, false);
				animation.addByPrefix('singUP', 'Frostiggy Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Frostiggy Right', 24, false);
				animation.addByPrefix('singLEFT', 'Frostiggy Left', 24, false);
				animation.addByPrefix('singDOWN', 'Frostiggy Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("Frostiggy Added Sucessfully.");

			case 'zuzy':
				noteSkin = 'purple';
				tex = Paths.getSparrowAtlas('characters/Zuzy_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Zuzy Idle', 24, false);
				animation.addByPrefix('singUP', 'Zuzy Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Zuzy Right', 24, false);
				animation.addByPrefix('singLEFT', 'Zuzy Left', 24, false);
				animation.addByPrefix('singDOWN', 'Zuzy Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("Zuzy Added Sucessfully.");

			case 'tio':
				noteSkin = 'dakoda';
				tex = Paths.getSparrowAtlas('characters/TIO_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tio Idle', 24, false);
				animation.addByPrefix('singUP', 'Tio Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Tio Right', 24, false);
				animation.addByPrefix('singLEFT', 'Tio Left', 24, false);
				animation.addByPrefix('singDOWN', 'Tio Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("TIO Added Sucessfully.");

			case 'poley':
				noteSkin = 'bf';
				tex = Paths.getSparrowAtlas('characters/Poley_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Poley Idle', 24, false);
				animation.addByPrefix('singUP', 'Poley Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Poley Right', 24, false);
				animation.addByPrefix('singLEFT', 'Poley Left', 24, false);
				animation.addByPrefix('singDOWN', 'Poley Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("Poley Added Sucessfully.");

			case 'felix':
				noteSkin = 'felix';
				tex = Paths.getSparrowAtlas('characters/Felix_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Felix Idle', 24, false);
				animation.addByPrefix('singUP', 'Felix Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Felix Right', 24, false);
				animation.addByPrefix('singLEFT', 'Felix Left', 24, false);
				animation.addByPrefix('singDOWN', 'Felix Down', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				trace("Felix Added Sucessfully.");

			case 'ombra':
				noteSkin = 'neonblack';
				tex = Paths.getSparrowAtlas('characters/Ombra_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Ombra Idle', 24);
				animation.addByPrefix('singUP', 'Ombra Up', 24);
				animation.addByPrefix('singRIGHT', 'Ombra Right', 24);
				animation.addByPrefix('singDOWN', 'Ombra Down', 24);
				animation.addByPrefix('singLEFT', 'Ombra Left', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');	

				trace("Ombra Added Sucessfully.");
		}

		dance();

		if (isPlayer)
		{
			// bruuhh nawww bruuhhh no way bruhh naw bruhhh fr? bruhhhhhh
			if (PlayState.SONG.player1 == 'zizzy')
				flipX = false;
			else
				flipX = !flipX;

			// Doesn't flip for Player and Zizzy, since their sprites are already in the right place???
			if (!curCharacter.startsWith('bf') && !curCharacter.startsWith('zizzy'))
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
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "offsets", library));

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
