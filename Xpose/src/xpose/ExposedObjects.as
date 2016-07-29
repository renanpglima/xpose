package xpose 
{
	import flash.sampler.getMemberNames;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class ExposedObjects
	{
		public var objects:Dictionary;
		public var attributeName:String;
		public var currentValue:*;
		public var type:String;
		
		public var changeLog:Array;
		//limite?
		//help?
		
		
		public function ExposedObjects(attributeName:String, value:*)
		{
			this.objects = new Dictionary(true);
			this.attributeName = attributeName;
			this.currentValue = value;
			this.type = getQualifiedClassName(value);
			this.changeLog = new Array();
		}
		
		public function addExposable(exposable:*) : void
		{
			this.objects[exposable] = "";
		}
		
		public function removeExposable(exposable:*) : void
		{
			delete this.objects[exposable];
		}
	}
}