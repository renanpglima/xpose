package gui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	
	import gui.children.GroupController;
	import gui.children.NumberController;
	import gui.children.ParameterController;
	import gui.children.StringController;
	
	import oboe.controllers.AutoSignal;
	import oboe.core.Controller;
	
	public class ParametersScreen extends Controller
	{
		private static const Y_MARGIN:Number = 10;
		
		private var tools:Array = new Array();
		
		private var nextYPos:Number = 45;
		
		private var btnRefresh:SimpleButton;
		
		private var fileManager:FileManager;
		
		public function ParametersScreen(displayObject:DisplayObject=null)
		{
			var bg:MovieClip = new BG();
			super(bg);
			
			fileManager = new FileManager();
			
			this.addChild(new AutoSignal());
		}
		
		[slot] public function onClickAddGroup() : void
		{
			var groupTools:Array = new Array;
					
//			trace("tools.length " + tools.length);
			for (var i:int = 0; i < this.tools.length; i++)
			{
				if(ParameterController(this.tools[i]).isSelected())
				{
					groupTools.push(this.tools[i]);
//					ParameterController(tools[i]).setParametersVisible(false);
					this.removeChild(this.tools[i]);
					
//					trace("selected " + i);
//					this.GroupController.group.add(tools[i]);					
				}			
			}

			var groupController:GroupController = new GroupController("Group",5, groupTools);
			
			this.tools.push(groupController);
			
		}
		
		[slot] public function onClickRemGroup() : void
		{
			for (var i:int = 0; i < this.tools.length; i++)
			{
				if(ParameterController(this.tools[i]).isSelected() && this.tools[i] is GroupController)
				{
					var vars:Array = GroupController(this.tools[i]).tools;
					
					for (var j:int = 0; j < vars.length; j ++)
					{
						this.tools.push(vars[j]);
					}
					
					this.removeChild(this.tools[i]);
				}
			}
			
			
			fileManager.save();
			removeParameters();
			loadParametersTools();
		}
		
		[slot] public function onClickRefresh() : void
		{
			this.removeParameters();
			this.loadParametersTools();
		}
		
		[slot] public function onClickLoad() : void
		{
			fileManager.load();
		}
		
		[slot] public function onClickSave() : void
		{
			fileManager.save();
		}
		
		private function removeParameters():void
		{
			for (var i:int = 0; i < tools.length; i++)
			{
				this.removeChild(tools[i]);
			}
			
			tools = new Array();
			nextYPos = 45;
		}
		
		private function loadParametersTools() : void
		{
			if (ExternalInterface.available)
			{
				var params:Array = ExternalInterface.call("getExposedParameters");
				
				if (params)
				{
					for (var i:int = 0; i < params.length; i++)
					{
						this.addNewFantasy(params[i]);
					}
				}
			}
		}
		
//		private function oldAddNewFantasy(fantasyName:String) : void
//		{
//			var type:String = ExternalInterface.call("getParameterType",fantasyName);
//			var value:* = ExternalInterface.call("getParameterValue", fantasyName);
//			
//			var parameterController:ParameterController;
//			
//			if (type == "Number" || type == "int")
//			{
//				parameterController = new NumberController(fantasyName, value);	
//			}
//			else if (type == "String")
//			{
//				parameterController = new StringController(fantasyName, value);	
//			}
//			else
//			{
//				trace ("type not supported!");
//			}
//			
//			if (parameterController)
//			{
//				nextYPos = parameterController.setPosition(0, nextYPos) + Y_MARGIN;
//				this.addChild(parameterController);
//				this.tools.push(parameterController);
//			}
//		}
		
		private function addNewFantasy(fantasyName:String, xPos:Number = 0) : void
		{
			var type:String = ExternalInterface.call("getParameterType",fantasyName);
			var value:* = ExternalInterface.call("getParameterValue", fantasyName);
			
			var parameterController:ParameterController;
			
			if (type == "Number" || type == "int")
			{
				parameterController = new NumberController(fantasyName, value);	
			}
			else if (type == "String")
			{
				parameterController = new StringController(fantasyName, value);	
			}
			else if (type == "Group")
			{
				var tools:Array = ExternalInterface.call("getGroupVars", fantasyName);
				parameterController = new GroupController(fantasyName, value, tools);
				
				for (var i:int = 0; i < tools.length; i++)
				{
					addNewFantasy(tools[i], xPos + 10);
				}
			}
			else
			{
				trace ("type not supported!");
			}
			
			if (parameterController)
			{
				nextYPos = parameterController.setPosition(xPos, nextYPos) + Y_MARGIN;
				this.addChild(parameterController);
				if (xPos == 0)
				{
					this.tools.push(parameterController);				
				}
			}
		}
		
		[slot] public function setParameterValue (fantasyName:String, value:*) : void
		{
			ExternalInterface.call("changeParameter", fantasyName, value);
		}
	}
}