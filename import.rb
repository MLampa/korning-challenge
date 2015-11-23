# Use this file to import the sales information into the
# the database.
require 'pry'
require "pg"
require 'csv'
system 'psql korning < schema.sql'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

@sales = []
  CSV.foreach('sales.csv', headers: true, header_converters: :symbol) do |row|
    show = row.to_hash
    @sales << show
  end

@uniq_employee = @sales.uniq {|sale| sale[:employee]}

@uniq_employee.each do |employee|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO employee (employee)
	    VALUES ($1)", [employee[:employee]])
    end
end

@uniq_customers = @sales.uniq {|sale| sale[:customer_and_account_no]}

@uniq_customers.each do |customer|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO customers (customer_and_account_no)
	    VALUES ($1)", [customer[:customer_and_account_no]])
    end
  end

@uniq_product = @sales.uniq {|sale| sale[:product_name]}

@uniq_product.each do |product|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO products (product_name)
	    VALUES ($1)", [product[:product_name]])
    end
  end

@uniq_product_sale = @sales.uniq {|sale| sale[:sale_date]}

@uniq_product_sale.each do |product_sale|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO products (sale_date)
	    VALUES ($1)", [product_sale[:product_sale]])
    end
  end

@uniq_product_sale_amount = @sales.uniq {|sale| sale[:sale_amount]}

@uniq_product_sale_amount.each do |sale_amount|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO products (sale_amount)
	    VALUES ($1)", [sale_amount[:sale_amount]])
    end
  end

@uniq_products_sold = @sales.uniq {|sale| sale[:units_sold]}

@uniq_products_sold.each do |products_sold|
  db_connection do |conn|
	    conn.exec_params("INSERT INTO products (units_sold)
	    VALUES ($1)", [products_sold[:units_sold]])
    end
  end

@uniq_invoice_frequency = @sales.uniq {|sale| sale[:invoice_frequency]}

@uniq_invoice_frequency.each do |invoice_freq|
  db_connection do |conn|
    conn.exec_params("INSERT INTO frequency (invoice_frequency)
    VALUES ($1)", [invoice_freq[:invoice_frequency]])
  end
end

@uniq_invoice = @sales.uniq {|sale| sale[:invoice_no]}

@uniq_invoice.each do |invoice|
  db_connection do |conn|
    conn.exec_params("INSERT INTO invoice (invoice_no)
    VALUES ($1)", [invoice[:invoice_no]])
  end
end

  @sales.each do |sale|
    employee_id = db_connection do |conn|
        conn.exec("SELECT id FROM employee
    	  WHERE employee = ($1)", [sale[:employee]])
        end

    customer_id = db_connection do |conn|
      conn.exec("SELECT id FROM customers
        WHERE customer_and_account_no = ($1)", [sale[:customer_and_account_no]])
        end

    products_id = db_connection do |conn|
      conn.exec("SELECT id FROM products
        WHERE product_name = ($1)", [sale[:product_name]])
        end

    frequency_id = db_connection do |conn|
      conn.exec("SELECT id FROM frequency
        WHERE invoice_frequency = ($1)", [sale[:invoice_frequency]])
        end

    invoice_id = db_connection do |conn|
      conn.exec("SELECT id FROM invoice
        WHERE invoice_no = ($1)", [sale[:invoice_no]])
        end


    db_connection do |conn|
        conn.exec("INSERT INTO sales (employee_id, customer_id, products_id, frequency_id, invoice_id)
        VALUES ($1, $2, $3, $4, $5)", [employee_id[0]['id'], customer_id[0]['id'], products_id[0]['id'], frequency_id[0]['id'], invoice_id[0]['id']])
    end
  end
