package xpose
{
	import flash.external.ExternalInterface;

	public class Xpose
	{	
		public static function init():void
		{
			ExternalInterface.addCallback("prepareParametersToSave", Xpose.prepareParametersToSave);
			ExternalInterface.addCallback("loadParameters", Xpose.loadParameters);
			ExternalInterface.addCallback("changeParameter", Xpose.changeParameter);
			ExternalInterface.addCallback("getExposedParameters", Xpose.getExposedParameters);
			ExternalInterface.addCallback("getParameterValue", Xpose.getParameterValue);
			ExternalInterface.addCallback("getParameterType", Xpose.getParameterType);
		}
		
		public static function register(exposable:*):void
		{	
			ParametersCollection.getInstance().lookupParameters(exposable);	
		}
		
		
		//FACADE FUNCTIONS
		public static function prepareParametersToSave() : String
		{
			return ParametersCollection.getInstance().prepareParametersToSave();
		}
		
		public static function loadParameters(data:String) : void
		{
			ParametersCollection.getInstance().loadParameters(data);
		}
		
		public static function changeParameter(fantasyName:String, value:*) : void
		{
			ParametersCollection.getInstance().changeParameter(fantasyName, value);
		}
		
		public static function getExposedParameters():Array
		{
			return ParametersCollection.getInstance().getExposedParameters();
		}
		
		public static function getParameterValue(fantasyName:String) : *
		{
			return ParametersCollection.getInstance().getParameterExposedObjects(fantasyName).currentValue;
		}
		
		public static function getParameterType(fantasyName:String):String
		{
			return ParametersCollection.getInstance().getParameterExposedObjects(fantasyName).type;
		}
	}
}