package classes.Items.Toys
{
	import classes.ItemSlotClass;
	import classes.GLOBAL;
	import classes.Creature;
	import classes.kGAMECLASS;	
	import classes.Characters.PlayerCharacter;
	import classes.GameData.TooltipManager;
	import classes.StringUtil;
	
	public class TamaniBionaHole extends ItemSlotClass
	{
		//constructor
		public function TamaniBionaHole()
		{
			this._latestVersion = 1;
			
			this.quantity = 1;
			this.stackSize = 1;
			this.type = GLOBAL.GADGET;
			
			//Used on inventory buttons
			this.shortName = "T.B.Hole";
			
			//Regular name
			this.longName = "Tamani Ultralux edition BionaHole";
			
			TooltipManager.addFullName(this.shortName, StringUtil.toTitleCase(this.longName));
			
			//Longass shit, not sure what used for yet.
			this.description = "a Tamani Ultralux edition BionaHole";
			
			//Displayed on tooltips during mouseovers
			this.tooltip = "A living sextoy, BionaHoles are cloned vaginas in advanced life-support sheaths. This particular model has a black casing with purple hearts on the side. The label tells you it’s cloned directly from CEO of TamaniCorp herself.";
			
			TooltipManager.addTooltip(this.shortName, this.tooltip);
			
			this.attackVerb = "";
			
			//Information
			this.basePrice = 5000;
			this.attack = 0;
			this.defense = 0;
			this.shieldDefense = 0;
			this.shields = 0;
			this.sexiness = 0;
			this.critBonus = 0;
			this.evasion = 0;
			this.fortification = 0;
			
			this.version = _latestVersion;
		}	
		//METHOD ACTING!
		override public function useFunction(target:Creature, usingCreature:Creature = null):Boolean
		{
			if(!kGAMECLASS.infiniteItems()) quantity++;
			if(target is PlayerCharacter) {
				if(!target.hasCock())
				{
					kGAMECLASS.clearOutput();
					kGAMECLASS.output("You don’t have the proper genitals to use this!");
				}
				else if(kGAMECLASS.rooms[kGAMECLASS.currentLocation].hasFlag(GLOBAL.NOFAP))
				{
					kGAMECLASS.clearOutput();
					kGAMECLASS.output("Masturbating here would be impossible.");
				}
				else if(kGAMECLASS.rooms[kGAMECLASS.currentLocation].hasFlag(GLOBAL.FAPPING_ILLEGAL))
				{
					kGAMECLASS.clearOutput();
					kGAMECLASS.output("Public masturbation is illegal here. Trying to masturbate would almost certainly land you in jail.");
				}
				else if(target.lust() < 33 || (kGAMECLASS.rooms[kGAMECLASS.currentLocation].hasFlag(GLOBAL.PUBLIC) && target.exhibitionism() < 33 && target.libido() < 70))
				{
					kGAMECLASS.clearOutput();
					kGAMECLASS.output("You cannot use the BionaHole at this time!");
				}
				else
				{
					kGAMECLASS.bionaholeUse("Tamani");
				}
			}
			else {
				kGAMECLASS.clearOutput();
				kGAMECLASS.output(target.capitalA + target.short + " cannot use the BionaHole.");
			}
			return true;
		}
	}
}
