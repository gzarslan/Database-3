 --***********************
 --Name:Gozde Arslan 
 --ID: 150320190 
 --Date: 16/04/2021
 --Purpose: Assignment 2 DBS311
  --***********************
  
  --finding customer--
  set SERVEROUTPUT On;
CREATE 
OR replace PROCEDURE find_customer(customerid IN number, found OUT number) IS
BEGIN
   SELECT
      COUNT(*) INTO found 
   FROM
      customers 
   WHERE
      customer_id = customerid;
exception 
WHEN
   no_data_found 
THEN
   found:= 0;
END
;
/ 
DECLARE 
found number;
BEGIN
   find_customer(100, found) ;
dbms_output.put_line('found is ' || found);
END
;
/

  --finding products--

CREATE 
OR replace PROCEDURE find_product(productid IN number, price OUT products.list_price % type) IS 
BEGIN
   SELECT
      list_price INTO price 
   FROM
      products 
   WHERE
      product_id = productid;
exception 
WHEN
   no_data_found 
THEN
   price:= 0;
END
;
/ 
DECLARE price number;
BEGIN
   find_product(112, price) ;
dbms_output.put_line('price is ' || price);
END
;
/

--add customer--
CREATE 
OR replace PROCEDURE add_order(customer_id IN number, new_order_id OUT number) IS max_order_id number;
BEGIN
   SELECT
      MAX(order_id) INTO max_order_id 
   FROM
      orders;
INSERT INTO
   orders 
VALUES
   (
      max_order_id + 1,
      customer_id,
      'Shipped',
      56,
      sysdate
   )
;
new_order_id:= max_order_id + 1;
END
;
/ 
DECLARE 
new_order_id NUMBER;
BEGIN
   add_order(112, new_order_id) ;
dbms_output.put_line('new order id is ' || new_order_id);
END
;
/
--add order item--
CREATE 
OR replace PROCEDURE add_order_item(orderId IN order_items.order_Id%type,
itemId IN order_items.item_Id%type,
productId IN order_items.product_Id%type,
quantity IN order_items.quantity%type,
price IN order_items.unit_price%type) IS

BEGIN
    INSERT INTO 
         order_items 
            VALUES(
                    orderId,
                    itemId,
                    productId, 
                    quantity, 
                    price
                );
END;

/
DECLARE 

BEGIN
   add_order_item(89,70,57,2,100.5) ;
      dbms_output.put_line('Rows Updated ');
   
   
END
;
/

