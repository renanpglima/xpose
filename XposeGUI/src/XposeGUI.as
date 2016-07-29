package
{
	import flash.display.Sprite;
	import flash.system.Security;
	
	import oboe.core.Oboe;
	
	[SWF(width="400", height="600", frameRate="10", backgroundColor="#FFFFFF")]
	public class XposeGUI extends Sprite
	{
		private var stateMachine:ScreenFlow;
		public function XposeGUI()
		{
			Security.allowDomain("*");
			
			Oboe.initOboe(
				{
					DEBUG : true,
					RESOURCES : "../resources/"
				}
			);
			
			this.stateMachine = new ScreenFlow( this );
		}
	}
}