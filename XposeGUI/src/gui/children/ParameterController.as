package gui.children
{
	
	import flash.display.MovieClip;
	
	import oboe.core.Controller;

	public class ParameterController extends Controller
	{
		protected var selected:Boolean;
		protected var asset:MovieClip;
		protected var value:*;
		protected var fantasyName:String;
		
		public function ParameterController(asset:MovieClip, fantasyName:String, value:*)
		{
			this.selected = false;
			this.asset = asset;
			this.value = value;
			this.fantasyName = fantasyName;
			
			super(asset);
		}
		
		[slot] public function setParametersVisible (visible:Boolean) : void
		{
			this.asset.visible = visible;
		}
		
		public function setPosition(x:Number, y:Number) : Number
		{
			this.asset.x = x;
			this.asset.y = y;
			return this.asset.y + this.asset.height;
		}
		
		protected function updateValue():void
		{
			this.signalUp("setParameterValue", fantasyName, value);
		}
		
		public function isSelected() : Boolean
		{
			return this.selected;
		}
	}
}