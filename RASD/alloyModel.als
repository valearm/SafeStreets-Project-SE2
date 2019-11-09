abstract sig Gender{}
one sig Male extends Gender{}
one sig Female extends Gender{}

abstract sig AvailabilityStatus{}
one sig Available extends AvailabilityStatus{}
one sig Unavailable extends AvailabilityStatus{}

abstract sig Customer {
email: one Email,
password: one Password,
}

sig FiscalCode{}
sig Email{}
sig Password{}
sig UniqueCode{}
sig City{}

sig User extends Customer {
// da decommentare, pulisco il modello
//name: one String,
//surname: one String,
//address: one String,
//gender: one Gender, //fact che specifica che il gender o è "Male" o "Female"
//age: one Int,
city: one City,
//fiscalcode: one FiscalCode, //fact che specifica che sia unico
position: one Position, 
}{
//age >= 18
}

sig Position {
coorX: one Int,
coorY: one Int,
}

sig Authority extends Customer {
forcename: one String,
referenceaddress: one String,
city: one City,
authoritymember: set AuthorityMember,
//ticket: set Ticket,
}

sig AuthorityMember extends Customer {
// da decommentare, per rendere modello più chiaro
//name: one String,
//surname: one String,
//uniqueCode: one UniqueCode, //fact che specifica che sia unico
availabilityStatus: one AvailabilityStatus, 
position: one Position,
authority: one Authority,
}

sig Notification {
notificationID: one Int, //fact che specifica che sia unico
//typeOfViolation: one String,
//date: one Int,
//time: one Int,
position: one Position,
referenceAuthorityName: one String,
//description: one String,
//historyStatus: one String,
user: one User,

}

sig Violation extends Notification {
violationID: one Int, // fact che specifica che sia unico
//readPlate: one String,
//report: one String,
authorityMember: one AuthorityMember,
}


/*
sig Ticket {
ticketId: one Int,
sanction: one String,
authority: one Authority,
}

sig Zone{
zoneId: one Int,
name: one String,
City: one String,
}

sig TicketStatistics{
mostEgregiousOffenders: some String,
ticket: some Ticket,
}
*/

//FACT

//CARDINALITY FACT

fact numberOfCustomer{
	Authority + AuthorityMember + User = Customer
}

fact noEmailWithoutCustomer {
	#Email=#Customer
}

fact noPassWithoutCustomer {
	#Password=#Customer
}

fact noSameDataCustomer{
no disjoint c1, c2: Customer | c1.email=c2.email or c1.password=c2.password
}
/*
fact UserHasAGender {
 	#Gender=#User
}

fact noUserGender{
all g:Gender| some u:User | g in u.gender
}

per

fact MemberAvailability{
	#availabilityStatus=#AuthorityMember
}

fact memberAvailability{
all av:AvailabilityStatus| some am:AuthorityMember | av in am.availabilityStatus
}

fact customerEmailIsUnique{
no disjoint c1,c2: Customer | c1.email = c2.email
}

fact authorityCodeIsUnique{
no disjoint am1,am2: AuthorityMember | am1.uniqueCode = am2.uniqueCode
}

fact UserFiscalCodeIsUnique{
no disjoint u1,u2: User | u1.fiscalcode= u2.fiscalcode
}
*/
fact allCityAssociated{
all c:City| some u1:User | c in u1.city
}

fact allCityAssociated2{
all c:City| some a1:Authority | c in a1.city
}

//fact noUserGender{
//all g:Gender| some u:User | g in u.gender
//}

fact allMemberOfAuthoritySameCity{
all a:Authority, am: AuthorityMember | (am in a.authoritymember) => (a.city = am.city)
}







// tripla (citta, indirizzo, force name) univoca
fact uniqueAuthorityInformation {
no disjoint a1, a2: Authority |	a1.city = a2.city and  
						a1.referenceaddress = a2.referenceaddress and 
						a1.forcename = a2.forcename
}

// una notifica (una vilazione) è associata ad un solo utente (un solo membro)
fact notificationHasUniqueUser {
all n: Notification | no u1, u2: User | n.notificationID in u1.notification.notificationID and
						    n.notificationID in u2.notification.notificationID 
}

// una violazione avvenuta in quella città deve avere un utente e una authority che interviene di quella città


// una violazione deve essere gestita da una authority specificata dall'utente


//una violazione deve avere come posizione quella dell'utente


//ogni autority collegata a una violazione deve essere unabvailable


//le autorityavailable non hanno violazioni (servono entrambi)










//ASSERT 

//CHECKING OF GENDER
/*
assert onGender{
all u1,u2:User | u1.gender = u2.gender
}*/


pred show { 
#User > 0
#AuthorityMember >0
#Authority > 0
#AuthorityMember > #Authority
#Notification > 0
#Violation > 0
#Notification >= #Violation
}

run show for 15 but 8 Int, exactly 5 String, exactly 2 User
