package pixlib.utils.resolvers {
	import pixlib.logging.logger;
	
	/**
	 * Resolve an instance of the given type.
	 * @param  argument  The argument used to determine the instance.
	 * @param  type      The type of the result.
	 * 
	 * <code>resolveInstance</code> is invoked with the argument.
	 * If the result is an instance of <code>type</code>, the result
	 * is returned. Otherwise, a message is logged and null is returned.
	 * 
	 * @see resolveInstance
	 */
	public function resolveInstanceOf(argument:Object, type:Class):Object {
		var instance:Object = resolveInstance(argument);
		
		if (instance == null)
			return null;
		
		if (instance is type)
			return instance;
		
		logger.error('Invalid resolve argument:  ' + argument + ', result must be an instance of ' + type);
		return null;
	}
	
}