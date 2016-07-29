package
{
	import flash.display.Sprite;
	
	import gui.ParametersScreen;
	
	import initialLoading.InitialLoading;
	
	import oboe.controllers.StateMachine;
	
	public class ScreenFlow extends StateMachine
	{
		public function ScreenFlow(mainSprite:Sprite, isRoot:Boolean=true)
		{
			super(mainSprite, isRoot);
			
			this.addState(InitialLoading, new InitialLoading());
			this.setState(InitialLoading);
		}
		
		[slot] public function onDoneLoading():void
		{
			this.addState(ParametersScreen, new ParametersScreen());
			this.setState(ParametersScreen);
		}
	}
}