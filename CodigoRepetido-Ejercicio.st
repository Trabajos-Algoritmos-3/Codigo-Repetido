!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: 'libroDeClientes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 15:21:06'!
BerificarQue: AClusure siFalla: ErrorQueOcurrio ejecutar: AnotherClosure
	AClusure
	on: ErrorQueOcurrio 
	do: AnotherClosure.! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/16/2021 22:11:26'!
agregarYSuspenderAlCliente: Cliente ACustomerBook: customerBook
	customerBook addCustomerNamed: Cliente .
	customerBook suspendCustomerNamed: Cliente.! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 21:18:07'!
calcularElTiempoEnMilisegundos: unBloqueDeCodigo
	^unBloqueDeCodigo timeToRun.	! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 14:29:18'!
crearCustomerBook
	libroDeClientes := CustomerBook new.! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 14:32:41'!
crearCustomerBookYAgregarUsuarioYDevolverSuNombre
	| JohnLennon |
	self crearCustomerBook.
	JohnLennon := 'John Lennon'.
	libroDeClientes addCustomerNamed: JohnLennon.
	^JohnLennon.
	! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 15:03:08'!
crearCustomerBookYAgregarUsuarioYSuspenderUsuarioYDevolverSuNombre
	| usuarioAgregadoAlLibroDeClientes |
	usuarioAgregadoAlLibroDeClientes := self crearCustomerBookYAgregarUsuarioYDevolverSuNombre.
	libroDeClientes suspendCustomerNamed: usuarioAgregadoAlLibroDeClientes.
	^usuarioAgregadoAlLibroDeClientes.! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 14:00:46'!
testearQue: tiempoDeEjecucion esMenorA: tiempoEsperadoDeEjecucion
	 ^(tiempoDeEjecucion ) < (tiempoEsperadoDeEjecucion).
	! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/18/2021 15:12:29'!
testearQueLaCantidadDeClientesActivosEs: cantidadDeClientesActivos yLaCantidadDeClientesSuspendidosEs: cantidadDeClientesSuspendidos yLaCantidadDeClientesEs: cantidadDeClientes.
	self assert: cantidadDeClientesActivos equals: libroDeClientes numberOfActiveCustomers.
	self assert: cantidadDeClientesSuspendidos equals: libroDeClientes numberOfSuspendedCustomers.
	self assert: cantidadDeClientes equals: libroDeClientes numberOfCustomers.
	! !

!CustomerBookTest methodsFor: 'funciones-para-test' stamp: 'fran 5/16/2021 21:28:15'!
tiempoActualEnMilisegundos
	^Time millisecondClockValue * millisecond.! !


!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:18:29'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	|  tiempoDeEjecucion |

	tiempoDeEjecucion := self calcularElTiempoEnMilisegundos: [ self crearCustomerBookYAgregarUsuarioYDevolverSuNombre ].
	
	self assert: (self testearQue: tiempoDeEjecucion  esMenorA: (50 * millisecond )).! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:19:05'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| nombreDelClienteABorrar tiempoDeEjecucion |
	
	nombreDelClienteABorrar := self crearCustomerBookYAgregarUsuarioYDevolverSuNombre. 
	 
	tiempoDeEjecucion := self calcularElTiempoEnMilisegundos: [libroDeClientes removeCustomerNamed: nombreDelClienteABorrar ].
	
	self assert: (self testearQue: tiempoDeEjecucion  esMenorA: (100 * millisecond )).
	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:15:57'!
test03CanNotAddACustomerWithEmptyName 

	self crearCustomerBook.
	
	
	self BerificarQue: [libroDeClientes addCustomerNamed: ''. self fail] 
		siFalla: Error
		ejecutar: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: libroDeClientes isEmpty ].! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:19:19'!
test04CanNotRemoveAnInvalidCustomer
	
	| clienteAgregadoAlLibroDeClientes |
			
	clienteAgregadoAlLibroDeClientes := self crearCustomerBookYAgregarUsuarioYDevolverSuNombre.
	
	self BerificarQue: [ libroDeClientes removeCustomerNamed: 'Paul McCartney'. self fail ] 
		siFalla: NotFound 
		ejecutar: [ :anError | 
			self assert: libroDeClientes numberOfCustomers = 1.
			self assert: (libroDeClientes includesCustomerNamed: clienteAgregadoAlLibroDeClientes) ]! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 15:12:46'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook
	
	| usuarioASuspenderDelLibroDeClientes |
	
	usuarioASuspenderDelLibroDeClientes := self crearCustomerBookYAgregarUsuarioYSuspenderUsuarioYDevolverSuNombre.
	
	self testearQueLaCantidadDeClientesActivosEs: 0 yLaCantidadDeClientesSuspendidosEs: 1 yLaCantidadDeClientesEs: 1.
	self assert: (libroDeClientes includesCustomerNamed: usuarioASuspenderDelLibroDeClientes).
	

	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 15:12:50'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| usuarioSuspendidoARemover |
	
	usuarioSuspendidoARemover := self crearCustomerBookYAgregarUsuarioYSuspenderUsuarioYDevolverSuNombre.
	libroDeClientes removeCustomerNamed: usuarioSuspendidoARemover.
	
	self testearQueLaCantidadDeClientesActivosEs: 0 yLaCantidadDeClientesSuspendidosEs: 0 yLaCantidadDeClientesEs: 0.
	self deny: (libroDeClientes includesCustomerNamed: usuarioSuspendidoARemover).


	
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:13:20'!
test07CanNotSuspendAnInvalidCustomer
	
	| usuarioAgregadoAlLibroDeClientes |
	
	usuarioAgregadoAlLibroDeClientes := self crearCustomerBookYAgregarUsuarioYDevolverSuNombre.
	
	self BerificarQue: [ libroDeClientes suspendCustomerNamed: 'Ringo Starr'. self fail ] 
		siFalla: CantSuspend
		ejecutar: [ :anError | 
				self assert: libroDeClientes numberOfCustomers = 1.
				self assert: (libroDeClientes includesCustomerNamed: usuarioAgregadoAlLibroDeClientes) ]
! !

!CustomerBookTest methodsFor: 'tests' stamp: 'fran 5/18/2021 21:14:24'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| usuarioaAgregadoYSuspendidoDelLibroDeClientes |
	
	usuarioaAgregadoYSuspendidoDelLibroDeClientes := self crearCustomerBookYAgregarUsuarioYSuspenderUsuarioYDevolverSuNombre.
	
	self BerificarQue: [ libroDeClientes suspendCustomerNamed: usuarioaAgregadoYSuspendidoDelLibroDeClientes. self fail ] 
		siFalla: CantSuspend
		ejecutar: [ :anError | 
				self assert: libroDeClientes numberOfCustomers = 1.
				self assert: (libroDeClientes includesCustomerNamed: usuarioaAgregadoYSuspendidoDelLibroDeClientes) ]! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'initialization' stamp: 'LL 10/30/2020 12:22:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'fran 5/18/2021 21:21:43'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName ) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'fran 5/18/2021 21:26:41'!
removeCustomerNamed: aName 

	active remove: aName ifAbsent: [ suspended remove: aName ifAbsent: [^NotFound signal]].
	^aName.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'fran 5/18/2021 21:30:01'!
suspendCustomerNamed: aName 

	active remove: aName ifAbsent: [ ^CantSuspend signal ].
	suspended add: aName.
	! !


!CustomerBook methodsFor: 'accessing' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'accessing' stamp: 'fran 5/18/2021 21:31:06'!
numberOfCustomers
	
	^self numberOfActiveCustomers + self numberOfSuspendedCustomers.! !

!CustomerBook methodsFor: 'accessing' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !


!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'signal errors' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'signal errors' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:18'!
customerAlreadyExistsErrorMessage

	^'Customer Already Exists'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:25'!
customerCanNotBeEmptyErrorMessage

	^'Customer Name Cannot Be Empty'! !
