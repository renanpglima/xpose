package initialLoading
{
	import flash.display.DisplayObject;
	
	import oboe.controllers.LoadingController;
	import oboe.resources.Files;
	
	public class InitialLoading extends LoadingController
	{
		public function InitialLoading()
		{
			super(1);
		}
		
		[slot] public function onEnterState():void
		{
			this.startLoading();
		}
		
		protected override function getPreloadList():Array
		{
			return [];
		}
		
		protected override function getLoadList():Array
		{
			return [];
		}
		
		protected override function onDoneLoading() : void 
		{
			this.signalUp("onDoneLoading");			
		}
	}
}