import flash.events.MouseEvent;
import flash.ui.Mouse;

import classes.StatBarSmall;
import classes.StatBarBig;
	
//Table of Contents
//0. PARSER
//1: TEXT FUNCTIONS
//2. DISPLAY STUFF
//3. UTILITY FUNCTIONS
//4. MOVEMENTS


function doParse(script:String, markdown=false):String 
{
	return parser.recursiveParser(script, markdown);
}


/*
MOST of this should be broken up into simple shim-functions that call the real, relevant function in userInterface:GUI
I'm breaking it out into a separate class, and just manipulating those class variables for the moment
once that's working, I can start piecemeal moving things to functions in GUI.

*/

//1: TEXT FUNCTIONS
public function output(words:String, markdown = false):void 
{
	this.userInterface.outputBuffer += doParse(words, markdown);
	this.userInterface.output();
}

public function clearOutput():void 
{
	this.userInterface.clearOutput();
}

public function output2(words:String, markdown = false):void
{
	this.userInterface.outputBuffer2 += doParse(words, markdown);
	this.userInterface.output2();
}

public function clearOutput2():void
{
	this.userInterface.clearOutput2();
}

public function num2Text(number:Number):String {
	var returnVar:String = null;
	var numWords = new Array("zero","one","two","three","four","five","six","seven","eight","nine","ten");
	if (number > 10 || int(number) != number) {
		returnVar = "" + number;
	} 
	else {
		returnVar = numWords[number];
	}
	return(returnVar);
}
public function num2Text2(number:int):String {
	var returnVar:String = null;
	var numWords = new Array("zero","first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth");
	if (number > 10) {
		returnVar = "" + number + "th";
	} 
	else {
		returnVar = numWords[number];
	}
	return(returnVar);
}

function author(arg:String):void 
{
	userInterface.author(arg);
}


function upperCase(str:String):String {
	var firstChar:String = str.substr(0,1);
	var restOfString:String = str.substr(1,str.length);
	return firstChar.toUpperCase()+restOfString.toLowerCase();
}
function plural(str:String):String {
	var lastChar:String = str.substr(str.length-1,str.length);
	if(lastChar == "s") str += "es";
	else str += "s";
	return str;
}
public function possessive(str:String):String {
	var lastChar:String = str.substr(str.length-1,str.length);
	if(lastChar == "s") str += "'";
	else str += "'s";
	return str;
}

function leftBarClear():void {
	this.userInterface.leftBarClear();
}
function hidePCStats():void {
	this.userInterface.hidePCStats()
}
function showPCStats():void {
	this.userInterface.showPCStats()
}
function showNPCStats():void {
	this.userInterface.showNPCStats()
}
function hideNPCStats():void {
	this.userInterface.hideNPCStats()
}
function showMinimap():void {
	this.userInterface.showMinimap();
}
function hideMinimap():void {
	this.userInterface.hideMinimap();
}
function deglow():void 
{
	this.userInterface.deglow()
}	
public function updatePCStats():void {
	if (pc.short != "uncreated")
		this.userInterface.setGuiPlayerNameText(pc.short);
	else
		this.userInterface.setGuiPlayerNameText("");

	updateStatBar(this.userInterface.playerShields,pc.shields(),pc.shieldsMax());

	updateStatBar(this.userInterface.playerHP,pc.HP(),pc.HPMax());
	updateStatBar(this.userInterface.playerLust,pc.lust(),pc.lustMax());
	updateStatBar(this.userInterface.playerEnergy,pc.energy(),pc.energyMax());
	
	updateStatBar(this.userInterface.playerPhysique,pc.physique(),pc.physiqueMax());	
	updateStatBar(this.userInterface.playerReflexes,pc.reflexes(),pc.reflexesMax());
	updateStatBar(this.userInterface.playerAim,pc.aim(),pc.aimMax());
	updateStatBar(this.userInterface.playerIntelligence,pc.intelligence(),pc.intelligenceMax());
	updateStatBar(this.userInterface.playerWillpower,pc.willpower(),pc.willpowerMax());
	updateStatBar(this.userInterface.playerLibido, pc.libido(), pc.libidoMax());
	updateStatBar(this.userInterface.playerXP, pc.XP(), pc.XPMax());

	
	this.userInterface.playerStatusEffects = this.chars["PC"].statusEffects;
	this.userInterface.playerLevel.values.text = pc.level;
	this.userInterface.playerCredits.values.text = pc.credits;
	
	this.userInterface.time = timeText();
	this.userInterface.days = String(days);
	this.userInterface.showSceneTag();
	
	updateNPCStats();
}
function timeText():String 
{
	var buffer:String = ""
	
	if (hours < 10)
	{
		buffer += "0";
	}
	
	buffer += hours + ":";
	
	if (minutes < 10) 
	{
		buffer += "0";
	}
	
	buffer += minutes;
	return buffer;
}

function updateNPCStats():void {
	if(foes.length >= 1) {
		updateStatBar(this.userInterface.monsterShield, foes[0].shields(),  foes[0].shieldsMax());
		updateStatBar(this.userInterface.monsterHP,     foes[0].HP(),       foes[0].HPMax());
		updateStatBar(this.userInterface.monsterLust,   foes[0].lust(),     foes[0].lustMax());
		updateStatBar(this.userInterface.monsterEnergy, foes[0].energy(),   foes[0].energyMax());
		
		this.userInterface.monsterLevel.values.text = String(foes[0].level);
		this.userInterface.monsterRace.values.text = StringUtil.toTitleCase(foes[0].originalRace);
		if(foes[0].hasCock()) {
			if(foes[0].hasVagina())	
				this.userInterface.monsterSex.values.text = "Hermaphrodite";
			else this.userInterface.monsterSex.values.text = "Male";
		}
		else if(foes[0].hasVagina()) this.userInterface.monsterSex.values.text = "Female";
		else this.userInterface.monsterSex.values.text = "????";
	}
}
function updateStatBar(arg:MovieClip,value = undefined, max = undefined):void {
	//if(title != "" && title is String) arg.masks.labels.text = title;
	if(max != undefined) 
		arg.setMax(max);
	if(value != undefined && arg.visible == true) 
	{
		if(arg.getGoal() != value) 
		{
			arg.setGoal(value);
			//conLog("SETTING GOAL");
		}
	}
}

public function setLocation(title:String, planet:String = "Error Planet", system:String = "Error System"):void 
{
	userInterface.setLocation(title, planet, system);
}

//3. UTILITY FUNCTIONS
function rand(max:Number):Number
{
	return int(Math.random()*max);
}

function cuntChange(arg:int,volume:Number,display:Boolean = true, spacingsF:Boolean = true,spacingsB:Boolean = false):Boolean {
	return holeChange(pc,arg,volume,display,spacingsF,spacingsB);
}
function buttChange(volume:Number,display:Boolean = true, spacingsF:Boolean = true,spacingsB:Boolean = false):Boolean {
	return holeChange(pc,-1,volume,display,spacingsF,spacingsB);
}
function cockChange(spacingsF:Boolean = true, spacingsB:Boolean = false):void {
	if (chars["PC"].cockVirgin && chars["PC"].hasCock())
	{
		chars["PC"].cockVirgin = false;
		if(spacingsF) output(" ");
		output("<b>You have succumbed to your desires and lost your </b>");
		if(chars["PC"].hasVagina()) output("<b>masculine </b>");
		output("<b>virginity.</b>");
		if(spacingsB) output(" ");
	}
}

function holeChange(target:Creature,hole:int,volume:Number,display:Boolean = true, spacingsF:Boolean = true, spacingsB:Boolean = false):Boolean {
	var stretched:Boolean = false;
	var devirgined:Boolean = false;
	var capacity:Number;
	var holePointer:VaginaClass;
	//Set capacity based on the hole.
	if(hole == -1) {
		capacity = target.analCapacity();
		holePointer = target.ass;
	}
	else {
		if(hole+1 > target.totalVaginas()) return false;
		else {
			capacity = target.vaginalCapacity(hole);
			holePointer = target.vaginas[hole];
		}
	}
	//cArea > capacity = autostreeeeetch.
	if(volume >= capacity) {
		if(holePointer.looseness >= 5) {}
		else holePointer.looseness++;
		stretched = true;
	}
	//If within top 10% of capacity, 50% stretch
	else if(volume >= .9 * capacity && rand(2) == 0) {
		holePointer.looseness++;
		stretched = true;
	}
	//if within 75th to 90th percentile, 25% stretch
	else if(volume >= .75 * capacity && rand(4) == 0) {
		holePointer.looseness++;
		stretched = true;
	}
	//If virgin
	if(holePointer.hymen || (hole < 0 && target.analVirgin) || (hole >= 0 && target.vaginalVirgin)) {
		if(spacingsF) output(" ");
		if(holePointer.hymen) output("<b>Your hymen is torn</b>");
		else output("<b>You have been penetrated</b>");
		if(hole >= 0 && target.vaginalVirgin) {
			target.vaginalVirgin = false;
			output("<b>, robbing you of your vaginal virginity</b>");
		}
		else if(target.analVirgin) {
			output("<b>, robbing you of your anal virginity</b>");
			target.analVirgin = false;
		}
		output("<b>.</b>");
		if(spacingsB) output(" ");
		devirgined = true;
	}
	//Delay anti-stretching
	if(volume >= .35 * capacity) {
		if(hole >= 0) {
			holePointer.shrinkCounter = 0;
		}
		else {
			holePointer.shrinkCounter = 0;
		}
	}
	if(stretched) {
		conLog("HOLE CODE #:" + hole + " STRETCHED TO " + holePointer.looseness + ".");
		//STRETCH SUCCESSFUL - begin flavor text if outputting it!
		if(display) {
			//Virgins get different formatting
			if(devirgined) {
				//If no spaces after virgin loss
				if(!spacingsB) output(" ");
			}
			//Non virgins as usual
			else if(spacingsF) output(" ");
			if(hole >= 0) {
				if(holePointer.looseness >= 5) output("<b>Your " + target.vaginaDescript(hole) + " is stretched painfully wide, gaped in a way that practically invites huge monster-cocks to plow you.</b>");
				else if(holePointer.looseness >= 4) output("<b>Your " + target.vaginaDescript(hole) + " painfully stretches, the lips now wide enough to gape slightly.</b>");
				else if(holePointer.looseness >= 3) output("<b>Your " + target.vaginaDescript(hole) + " is now somewhat loose.</b>");
				else if(holePointer.looseness >= 2) output("<b>Your " + target.vaginaDescript(hole) + " is a little more used to insertions.</b>");
				else output("<b>Your " + target.vaginaDescript(hole) + " is stretched out a little bit.</b>");
			}
			else {
				if(holePointer.looseness >= 5) output("<b>Your " + target.assholeDescript() + " is stretched painfully wide, gaped in a way that practically invites huge monster-cocks to plow you.</b>");
				else if(holePointer.looseness >= 4) output("<b>Your " + target.assholeDescript() + " painfully dilates, the pucker now able to gape slightly.</b>");
				else if(holePointer.looseness >= 3) output("<b>Your " + target.assholeDescript() + " is now somewhat loose.</b>");
				else if(holePointer.looseness >= 2) output("<b>Your " + target.assholeDescript() + " is a little more used to insertions.</b>");
				else output("<b>Your " + target.assholeDescript() + " is stretched out a little bit.</b>");
			}
			if(spacingsB) output(" ");
		}
	}
	return (stretched || devirgined);
}
function clearList():void {
	list = new Array();
}
var list:Array = new Array();
function addToList(arg):void {
	list[list.length] = arg;
}
function formatList():String {
	var stuff:String = "";
	if(list.length == 1) return list[0];
	for(var x:int = 0; x < list.length; x++) {
		stuff += list[x];
		if(list.length == 2 && x == 0) {
			stuff += " and ";
		}
		else if(x < list.length-2) {
			stuff += ", ";
		}
		else if(x < list.length-1) {
			stuff += ", and ";
		}
	}
	list = new Array();
	return stuff;	
}

//4. MOVEMENTS