package gui
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;

	public class FileManager
	{
		private var fr:FileReference;
		
		public function FileManager()
		{
			fr = new FileReference();
		}
		
		public function save():void
		{
			fr.addEventListener(Event.COMPLETE, onSave);
			fr.addEventListener(Event.CANCEL, onCancel);
			fr.addEventListener(IOErrorEvent.IO_ERROR, error);
			
			var parameters:String = ExternalInterface.call("prepareParametersToSave");
			
			fr.save(parameters);
		}
		
		public function load():void
		{	
			fr.addEventListener(Event.SELECT, onFileSelected);
			fr.addEventListener(Event.CANCEL, onCancel);
			fr.addEventListener(IOErrorEvent.IO_ERROR, error);
			
			fr.browse();
		}
		
		private function onFileSelected(event:Event) : void
		{	
			fr.addEventListener(Event.COMPLETE, onLoad);
			fr.addEventListener(IOErrorEvent.IO_ERROR, error);
			
			fr.load();
		}
		
		private function onLoad(event:Event):void
		{	
			ExternalInterface.call("loadParameters", fr.data.toString());
			
			this.removeListeners();
			
			trace ("arquivo carregado! - " + fr.data.toString());
		}
		
		private function onSave(event:Event) : void
		{	
			ExternalInterface.call("alert('Arquivo salvo com sucesso!')");
			
			this.removeListeners();
		}
		
		private function onCancel(event:Event) : void
		{
			this.removeListeners();
		}
		
		private function error(event:IOErrorEvent) : void
		{
			this.removeListeners();
		}
		
		private function removeListeners():void
		{
			fr.removeEventListener(Event.SELECT, onFileSelected);
			fr.removeEventListener(Event.CANCEL, onCancel);
			fr.removeEventListener(Event.COMPLETE, onSave);
			fr.removeEventListener(Event.COMPLETE, onLoad);
			fr.removeEventListener(IOErrorEvent.IO_ERROR, error);
		}
	}
}