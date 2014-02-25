﻿package classes.DataManager.Serialization 
{
	import classes.DataManager.Serialization.ISaveable;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	import classes.kGAMECLASS;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public class UnversionedSaveable implements ISaveable
	{
		protected var _ignoredFields:Array = ["prototype"];
		public function addIgnoredField(fieldName:String):void
		{
			_ignoredFields.push(fieldName);
		}
		
		private function isBasicType(obj:*):Boolean
		{
			if (obj is int) return true;
			if (obj is Number) return true;
			if (obj is String) return true;
			if (obj is Boolean) return true;
			if (obj is uint) return true;
			return false;
		}
		
		// Serialization shit
		public function getSaveObject():Object
		{
			var dataObject:Object = new Object();
			
			var _d:XML = describeType(this);
			var _dl:XMLList = _d..variable;
			var _da:XMLList = _d..accessor;
			
			// Raw properties
			for each (var prop:XML in _dl)
			{
				if (this[prop.@name] != null && this[prop.@name] != undefined)
				{
					if (this[prop.@name] is ISaveable)
					{
						dataObject[prop.@name] = this[prop.@name].getSaveObject();
					}
					else if (this[prop.@name] is Array)
					{
						if (this[prop.@name].length > 0)
						{
							if (this[prop.@name][0] is ISaveable)
							{
								dataObject[prop.@name] = new Array();
								
								for (var i:int = 0; i < this[prop.@name].length; i++)
								{
									dataObject[prop.@name].push(this[prop.@name][i].getSaveObject());
								}
							}
							else if (isBasicType(this[prop.@name][0]))
							{
								dataObject[prop.@name] = new Array();
								
								for (var i:int = 0; i < this[prop.@name].length; i++)
								{
									dataObject[prop.@name].push(this[prop.@name][i]);
								}
							}
							else
							{
								dataObject[prop.@name] = this[prop.@name];
								kGAMECLASS.conLog("Potential serialization issue with property: " + prop.@name);
							}
						}
						else
						{
							dataObject[prop.@name] = new Array();
						}
					}
					else if (isBasicType(this[prop.@name]))
					{
						dataObject[prop.@name] = this[prop.@name];
					}
					else
					{
						dataObject[prop.@name] = this[prop.@name];
						kGAMECLASS.conLog("Potential serialization issue with property: " + prop.@name);
					}
				}
			}
			
			// Private properties aren't in the ..variable list at all. We can however, get their accessors...
			for each (var accs:XML in _da)
			{
				if (_ignoredFields.length > 0)
				{
					if (_ignoredFields.indexOf(accs.@name) == -1)
					{
						dataObject[accs.@name] = this[accs.@name];
					}
				}
				else
				{
					if (accs.@name != "prototype" && accs.@name != "neverSerialize")
					{
						dataObject[accs.@name] = this[accs.@name];
					}
				}
			}
			
			// Save the class instance string
			dataObject.classInstance = getQualifiedClassName(this);
			
			return dataObject;
		}
		
		public function loadSaveObject(dataObject:Object):void
		{
			// tldr, v1 versions of the saves, because they use embedded AMF metadata, the loaded data is no longer a Dynamic class, which means
			// for * in thing doesn't work.
			var _d:XML = describeType(dataObject);
			if (_d.@isDynamic == "true")
			{
				// Dynamic objects ie v2+ saves
				for (var prop in dataObject)
				{
					if (prop != "prototype" && prop != "neverSerialize" && prop != "classInstance")
					{
						// Directly referencing something that supports this serialization method
						if (this[prop] is ISaveable)
						{
							var classT:Class = getDefinitionByName(dataObject[prop].classInstance) as Class;
							this[prop] = new classT();
							this[prop].loadSaveObject(dataObject[prop]);
						}
						// Refering an array...
						else if (this[prop] is Array)
						{							
							if (dataObject[prop].length > 0)
							{
								this[prop] = new Array();
								
								// Whose children support this serialization method
								if (dataObject[prop][0].hasOwnProperty("classInstance"))
								{
									for (var i:int = 0; i < dataObject[prop].length; i++)
									{	
										var tItem:ISaveable = new (getDefinitionByName(dataObject[prop][i].classInstance) as Class)();
										tItem.loadSaveObject(dataObject[prop][i]);
										this[prop].push(tItem);
									}
								}
								// Or possibly store basic data types
								else
								{
									this[prop] = dataObject[prop];
								}
							}
							// Or the array is empty and we can make no assumptions about what it's supposed to store
							else
							{
								this[prop] = new Array();
							}
						}
						// Or we're looking at a base data type or a class that doesn't yet implement an ISaveable interface
						else
						{
							this[prop] = dataObject[prop];
						}
					}
				}
			}
			// This is some workaround code that probably won't work or be called ever.
			else
			{
				// "AMF Metadata" classed objects, ie, not dynamic.
				var _dl:XMLList = _d..variable;
				var _da:XMLList = _d..accessor;
				
				for each (var prop in _dl)
				{
					if (this[prop.@name] != null && this[prop.@name] != undefined)
					{
						this[prop.@name] = dataObject[prop.@name];
					}
				}
				
				for each (var accs in _da)
				{
					if (accs.@name != "prototype" && accs.@name != "neverSerialize")
					{
						this[accs.@name] = dataObject[accs.@name];
					}
				}
			}
		}
		
		public function makeCopy():*
		{
			var classT:Class = (getDefinitionByName(getQualifiedClassName(this)) as Class);
			var cObj:* = new classT();
			cObj.loadSaveObject(this.getSaveObject());
			return cObj;
		}
	}
}