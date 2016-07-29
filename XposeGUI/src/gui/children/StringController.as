package gui.children
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import oboe.core.Oboe;

	public class StringController extends ParameterController
	{
		
		public function StringController(fantasyName:String, value:*)
		{	
			this.asset = new StringTool();	
			this.asset.txtParameterValue.text = value;
			this.asset.txtParameterName.text = fantasyName;
			
			super (this.asset, fantasyName, value);
			this.asset.txtParameterValue.addEventListener(KeyboardEvent.KEY_DOWN, textChanged);
		}
		
		private function textChanged(event:KeyboardEvent):void
		{
			// if the key is ENTER
			if(event.charCode == 13){
				
				var newValue:String = this.asset.txtParameterValue.text;
				this.value = newValue;
				this.asset.txtParameterValue.text = this.value;
				this.updateValue();
			}
		}
	}
}