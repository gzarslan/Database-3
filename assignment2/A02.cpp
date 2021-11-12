/* Gozde Arslan */
/* DBS final project */


#include <iostream>
#include <string>
#include <occi.h>
#include <cctype>

using oracle::occi::Environment;
using oracle::occi::Connection;

using namespace oracle::occi;
using namespace std;

struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};

//main menu 
int mainMenu() {
	int chose = 0;
	do {
		cout << "******************** Main Menu ********************\n"
			<< "1)\tLogin\n"
			<< "0)\tExit\n";

		if (chose != 0 && chose != 1) {
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
			cout << "Enter an option (0-1): ";

		cin >> chose;
	} while (chose != 0 && chose != 1);

	return chose;
}



//receives the customer info to connect database
int customerLogin(Connection* conn, int customerId) {

	Statement* stmt = conn->createStatement();
	stmt->setSQL("BEGIN find_customer(:1, :2); END;");
	int search_id;
	stmt->setInt(1, customerId);
	stmt->registerOutParam(2, Type::OCCIINT, sizeof(search_id));
	stmt->executeUpdate();
	search_id = stmt->getInt(2);
	conn->terminateStatement(stmt);

	return search_id;
}
//the function finds the product that user enter 
double findProduct(Connection* conn, int product_id) {
	Statement* stmt = conn->createStatement();
	stmt->setSQL("BEGIN find_product(:1, :2); END;");
	double price;
	stmt->setInt(1, product_id);
	stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));
	stmt->executeUpdate();
	price = stmt->getDouble(2);
	conn->terminateStatement(stmt);

	if (price > 0) {
		return price;
	}
	else
	{
		return 0;
	}
}

//adds in to cart
int addToCart(Connection* conn, struct ShoppingCart cart[]) {
	cout << "-------------- Add Products to Cart --------------" << endl;
	int cnt = 0;
	while (cnt < 5) {


		int productID;
		int product_quantity;
		ShoppingCart list;
		int chose;

		do {
			cout << "Enter the product ID: ";
			cin >> productID;

			if (findProduct(conn, productID) == 0) {
				cout << "The product does not exist. Try again..." << endl;
			}
		} while (findProduct(conn, productID) == 0);

		cout << "Product Price: " << findProduct(conn, productID) << endl;
		cout << "Enter the product Quantity: ";
		cin >> product_quantity;

		list.product_id = productID;
		list.price = findProduct(conn, productID);	// Error handling
		list.quantity = product_quantity;
		cart[cnt] = list;

		if (cnt == 4)
			return cnt + 1;
		else {
			do {
				cout << "Enter 1 to add more products or 0 to check out: ";
				cin >> chose;
			} while (chose != 0 && chose != 1);
		}

		if (chose == 0) {
			return cnt + 1;
		}

		++cnt;
	}
}




//this function provides to user checkout
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
	char select; //user selection 
	do {
		cout << "Would you like to checkout ? (Y / y or N / n) ";
		cin >> select;
		//if user do not select Y or y it will print error msg
		if (select != 'Y' && select != 'y' && select != 'N' && select != 'n')
			cout << "Wrong input. Try again..." << endl;
	} while (select != 'Y' && select != 'y' && select != 'N' && select != 'n'); //this loop will work till not enter Y or y

	if (select == 'N' || select == 'n') { //if user choose n it will return cancelation
		cout << "The order is cancelled." << endl;
		return 0;
	}
	else {

		Statement* stmt = conn->createStatement();
		stmt->setSQL("BEGIN add_order(:1, :2); END;");
		int orderId;
		stmt->setInt(1, customerId);
		stmt->registerOutParam(2, Type::OCCIINT, sizeof(orderId));
		stmt->executeUpdate();
		orderId = stmt->getInt(2);

		int i = 0;
		while (i < productCount) {
			stmt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");
			stmt->setInt(1, orderId);
			stmt->setInt(2, i + 1);
			stmt->setInt(3, cart[i].product_id);
			stmt->setInt(4, cart[i].quantity);
			stmt->setDouble(5, cart[i].price);
			stmt->executeUpdate();
			++i;
		}

		cout << "The order is successfully completed." << endl;
		conn->terminateStatement(stmt);

		return 1;
	}
}


//this functiondisplays products by ordered
void displayProducts(struct ShoppingCart cart[], int productCount) {
	if (productCount > 0) {
		double total = 0;
		cout << "------- Ordered Products ---------" << endl;
		for (int i = 0; i < productCount; ++i) { //loops all the prorudcts in the cart and print their values
			cout << "---Item " << i + 1 << endl;
			cout << "Product ID: " << cart[i].product_id << endl;
			cout << "Price: " << cart[i].price << endl;
			cout << "Quantity: " << cart[i].quantity << endl;
			total += cart[i].price * cart[i].quantity;
		}
		cout << "----------------------------------\nTotal: " << total << endl;
	}
}



//main function 
int main() {
	Environment* env = nullptr;
	Connection* conn = nullptr;
	//connect to database
	string user = "dbs311_211f07";
	string pass = "25281307";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

	try {
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		cout << "Connection is successful!" << endl;


		int chose;
		int customerId;
		do {

			//the selection equal to menu option (0-1)
			chose = mainMenu();

			if (chose == 1) {
				cout << "Enter the customer ID: ";
				cin >> customerId;
				//if the id is canot find print error message
				if (customerLogin(conn, customerId) == 0) {
					cout << "The customer does not exist." << endl;
				}
				else {
					ShoppingCart cart[5];
					//insert values into the cart
					int count = addToCart(conn, cart);
					displayProducts(cart, count);
					checkout(conn, cart, customerId, count);
				}

			}


		} while (chose != 0);S
		cout << "Good bye!..." << endl;

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp) {
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	return 0;
}
