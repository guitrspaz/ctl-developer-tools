/**
 * A rule to be used in a rule book to evaluate conditions against facts to do something in the system.
 * A rule is to be execute via the format of given( facts ).when( some condition given facts ).then( do something )
 */
component accessors="true"{

	// DI
	property name="logger" 	inject="logbox:logger:{this}";

	/**
	 * The rule name
	 */
	property name="name";

	/**
	 * The rulebook this rule belongs to
	 */
	property name="ruleBook";

	/**
	 * The current state of the rule
	 */
	property name="currentState";

	/**
	 * The facts given to the rule
	 */
	property name="facts" type="struct";

	/**
	 * This struct tracks facts assigned to specific `using().then()` method executions
	 */
	property name="factsNameMap" type="struct";

	/**
	 * The next rule to execute if this rule is ran.  This rule can be null
	 */
	property name="nextRule";

	/**
	 * The predicate closure, there can only be one per rule defined
	 */
	property name="predicate";

	/**
	 * The except closure, there can only be one per rule defined
	 */
	property name="except";

	/**
	 * An array of consumers registered in this rule.  Basically multiple `then()` calls using different facts
	 */
	property name="consumers";

	/**
	 * The result value; this should be set for RuleBooks that are expected to produce a Result.
	 */
	property name="result" type="any";

	// Static enum for valid states for rules
	this.STATES = {
		NEXT = "NEXT",
		STOP = "STOP"
	};

	/**
	 * Constructor
	 *
	 * @name The name of the rule, if empty, we assign it a UUID
	 */
	Rule function init( name=createUUID() ){
		// Setup properties
		variables.name 			= arguments.name;
		variables.facts 		= {};
		variables.factsNameMap 	= {};
		variables.currentState 	= this.STATES.NEXT;

		// Define an empty predicate that always returns true
		variables.predicate = function(){
			return true;
		};

		// Define an empty except that always returns false
		variables.except = function(){
			return false;
		};

		// Create the consumers array
		variables.consumers = [];

		return this;
	}

	/**
	 * Set the result in the rule
	 *
	 * @result The result object
	 */
	Rule function setResult( required result ){
		variables.result = arguments.result;
		return this;
	}

	/**
	 * The given() method accepts a key/value pair as a Fact for this Rule.
	 *
	 * @name The unique name of the fact
	 * @value The value of the fact
	 */
	Rule function given( required name, required value ){
		variables.facts[ arguments.name ] = arguments.value;
		return this;
	}

	/**
	 * The givenAll() method accepts all the Facts for this Rule.
	 *
	 * @facts The structure of facts to store
	 * @overwrite Overwrite facts if they exist already, defaults to true
	 */
	Rule function givenAll( required struct facts, boolean overwrite=true ){
		structAppend( variables.facts, arguments.facts, true );
		return this;
	}

	/**
	 * This method evaluates the rule against the predicate set in the rule via the `when()` method.
	 *
	 * @facts A structure of name-value pairs representing the facts in this rulebook
	 * @overwrite Overwrite the facts if they exist or not, defauls to true
	 */
	void function run( struct facts={}, boolean overwrite=true ){

		// Do assignment of facts if passed
		this.givenAll( argumentCollection=arguments );

		if(
			// Check the predicate is TRUE
			variables.predicate( variables.facts )
			&&
			// Check the except is FALSE
			!variables.except( variables.facts )
		){

			// iterate through the then() actions specified since our predicate passed
			var stopConsumerChain = false;
			variables.consumers.each( function( action, index ){
				if( stopConsumerChain ){ return; }

				// default to use all facts
				var targetFacts = variables.facts;

				// Check if we filtered the facts using the `using()` methods
				if( variables.factsNameMap.keyExists( index ) ){
					// filter out only the names we need
					targetFacts = variables.facts.filter( function( key, value ){
						return( variables.factsNameMap[ index ].findNoCase( key ) );
					} );
				}

				// Invoke the consumer action with facts and result object
				var stopConsumers = action( targetFacts, variables.result );

				if( !isNull( stopConsumers ) && stopConsumers ){
					stopConsumerChain = true;
				}

			} ); // End iteration of consumer actions

			// Register in the status Map
			variables.ruleBook.getRuleStatusMap().put( variables.name, variables.ruleBook.RULE_STATES.EXECUTED );

			// if stop() was invoked, stop the rule chain after then is finished executing
			if( variables.currentState == this.STATES.STOP ){
				variables.ruleBook.getRuleStatusMap().put( variables.name, variables.ruleBook.RULE_STATES.STOPPED );
				return;
			}

		} // end if predicate was true
		else {
			logger.debug( "Predicate was false, skipping rule (#variables.name#)" );
			variables.ruleBook.getRuleStatusMap().put( variables.name, variables.ruleBook.RULE_STATES.SKIPPED );
		}

		// Continue down the rule rabbit hole and pass the facts along
		if( !isNull( variables.nextRule ) ){
			variables.nextRule
				.setResult( variables.result )
				.run( argumentCollection=arguments );
		}

	}

	/**
	 * When methods accept a Predicate closure/lambda that evaluates a condition based on the Facts provided. Only one when() method can be specified per Rule.
	 *
	 * The predicate is a closure that takes in one argument and MUST return boolean
	 * <pre>
	 * boolean function( factBook ){
	 * }
	 * </pre>
	 *
	 * @predicate A predicate closure/lambda that accepts a factbook struct and MUST return boolean: ( factBook ) => boolean
	 */
	Rule function when( required predicate ){
		variables.predicate = arguments.predicate;
		return this;
	}

	/**
	 * Except methods accept a closure/lambda that evaluates a condition based on the Facts provided. Only one except() method can be specified per Rule.
	 *
	 * The except is a closure that takes in one argument and MUST return boolean, if true then the when is negated and no consumers are fired.
	 * If false, then when() operation is still valid and the consumers are fired.
	 * <pre>
	 * boolean function( facts ){
	 * }
	 * </pre>
	 *
	 * @except A closure/lambda that accepts a facts struct and MUST return boolean: ( facts ) => boolean
	 */
	Rule function except( required except ){
		variables.except = arguments.except;
		return this;
	}

	/**
	 * Then methods accept a Consumer closure that describe the action to be invoked if the condition in the when() method evaluates to true. There can be multiple then() methods specified in a Rule that will all be invoked in the order they are specified if the when() condition evaluates to true.
	 *
	 * The consumer closure takes in one argument and returns void.  The argument can be of two types:
	 * - Single Fact : Which can be of any type
	 * - Struct of Facts : A collection of facts assigned to it
	 * <pre>
	 * void function( any singleFact ){
	 * }
	 *
	 * void function( struct facts ){
	 * }
	 * </pre>
	 *
	 * @consumer A consumer based closure/lambda t
	 */
	Rule function then( required consumer ){
		variables.consumers.append( arguments.consumer );
		return this;
	}

	/**
	 * The stop() method causes the rule chain to stop if the when() condition is true and only after the then() actions have been executed.
	 */
	Rule function stop(){
		variables.currentState = this.STATES.STOP;
		return this;
	}

	/**
	 * Using methods reduce the set of facts available to a `then()` method. Multiple using() methods can also be chained together if so desired. The aggregate of the facts with the names specified in all using() methods immediately preceeding a then() method will be made available to that then() method
	 *
	 * @factNames An array of names or a string list of fact names to store for the next `then()` execution.
	 */
	function using( required factNames ){
		var consumerIndex = variables.consumers.len() + 1;

		// Build up to an array if a simple list is used.
		if( isSimpleValue( arguments.factNames ) ){
			arguments.factNames = listToArray( arguments.factnames );
		}

		// Do we already have this consumer pegged? In case of multiple: using().using() calls
		if( variables.factsNameMap.keyExists( consumerIndex ) ){
			// Append to the array
			variables.factsNameMap[ consumerIndex ].append( arguments.factNames, true );
			return this;
		}

		// Store the fact names for this iteration of consumers
		variables.factsNameMap[ consumerIndex ] = arguments.factNames;
		return this;
	}

	/**
	 * Set the next rule in the chain of rules
	 *
	 * @rule The rule to tie into this rule chain
	 */
	Rule function setNextRule( required rule ){
		variables.nextRule = arguments.rule;
		return this;
	}

}