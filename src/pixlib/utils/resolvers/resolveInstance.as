package pixlib.utils.resolvers {
	import flash.utils.getDefinitionByName;
	
	import pixlib.logging.logger;
	
	/**
	 * Resolve an instance.
	 * @param  argument  The argument used to determine the instance.
	 * 
	 * If <code>argument</code> is null, null is returned.
	 * 
	 * If <code>argument</code> is a <code>Function</code> (signature
	 * must be compatible with <code>function():Object</code>), the
	 * function is invoked and the return value is used as argument
	 * in the next step.
	 * 
	 * If <code>argument</code> is a <code>String</code>, it is assumed to
	 * be a class name. The class is resolved and used as argument in the
	 * next step.
	 * If the class fails to resolve, a message is logged and null is returned.
	 * 
	 * If <code>argument</code> is a <code>Class</code>, the class is
	 * instanciated (the constructor must have zero parameters) and the
	 * instance is used as argument in the next step.
	 * 
	 * <code>argument</code> is returned.
	 */
	public function resolveInstance(argument:Object):Object {
		if (argument == null)
			return null;
		
		if (argument is Function)
			argument = argument();
		
		if (argument is String) {
			try {
				argument = Class(getDefinitionByName(argument as String));
			} catch (error:Error) {
				logger.error('Invalid class name:  ' + argument);
				return null;
			}
		}
		
		if (argument is Class)
			argument = new argument();
		
		return argument;
	}
	
}