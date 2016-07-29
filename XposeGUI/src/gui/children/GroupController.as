package gui.children
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import oboe.core.Oboe;
	
	public class GroupController extends ParameterController
	{
		private var _tools:Array; 
		
		public function GroupController(fantasyName:String, value:*, tools:Array)
		{	
			this._tools = tools;
			
			this.asset = new NumericTool();	
			this.asset.txtParameterValue.text = value;
			this.asset.txtParameterName.text = fantasyName;
			
			super (this.asset, fantasyName, value);
			
			//this.asset.btnSelect.addEventListener(MouseEvent.CLICK, onClickSelect);
			this.asset.btnUp.addEventListener(MouseEvent.CLICK, onClickUp);
			this.asset.btnDown.addEventListener(MouseEvent.CLICK, onClickDown);
			this.asset.txtParameterValue.addEventListener(KeyboardEvent.KEY_DOWN, textChanged);
		}
		
		private function buttonToggle(button:SimpleButton):void
		{
			var currDown:DisplayObject = button.hitTestState;
			button.hitTestState = button.upState;
			button.upState = currDown;
			this.selected = !this.selected;
		}
		
		private function onClickSelect(event:MouseEvent):void
		{
			buttonToggle(this.asset.btnSelect);
		}
		
		private function onClickDown(event:MouseEvent):void
		{
			this.value--;
			this.asset.txtParameterValue.text = this.value; 
			this.updateValue();
		}
		
		private function onClickUp(event:MouseEvent):void
		{
			this.value++;
			this.asset.txtParameterValue.text = this.value;
			this.updateValue();
		}
		
		private function textChanged(event:KeyboardEvent):void
		{
			// if the key is ENTER
			if(event.charCode == 13){
				
				var newValue:Number = Number(this.asset.txtParameterValue.text);
				this.value = newValue;
				this.asset.txtParameterValue.text = this.value;
				this.updateValue();
			}
			
		}

		public function get tools():Array
		{
			return _tools;
		}

		public function set tools(value:Array):void
		{
			_tools = value;
		}

	}
}