defmodule ThamaniWeb.DispatchWarehouseController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches
  alias Thamani.Warehouse_orders
  alias Thamani.Breakbulks
  alias Thamani.Inventories
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "dispatch__warehouse" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    dispatch__warehouse =
      user
      |> user_dispatch
      |> Repo.all()
      |> Repo.preload(:companies)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if dispatch__warehouse do
      render(
        conn,
        "index.html",
        dispatch__warehouse: dispatch__warehouse,
        count_7: count_7,
        count_order: count_order,
        user: user,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: dispatch_warehouse_path(conn, :index))
    end
  end

  def new(conn, params, current_user) do
    bat = Dispatches_Warehouse.get_items(current_user)
    code = Breakbulks.list_breakbulk!(current_user.id)
    company = Dispatches_Warehouse.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:dispatches_warehouse)
      |> Dispatch_Warehouse.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      code: code,
      count_7: count_7,
      count_order: count_order,
      company: company,
      count_stock: count_stock,
      map: "map",
      item: "",
      retailer: "",
      from_name: "",
      to_name: "",
      quantity: "",
      description: "",
      order: "",
      amount: "",
      eta: "",
      etd: "",
      currency: "",
      distance: "",
      loader_class: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " "
    )
  end

  def create(
        conn,
        %{
          "dispatch__warehouse" => %{
            "item" => item,
            "retailer" => retailer,
            "transporter" => transporter,
            "transporterid" => transporterid,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    bat = Dispatches_Warehouse.get_items(current_user)
    code = Breakbulks.list_breakbulk!(current_user.id)

    last =
      case Dispatches_Warehouse.get_last_id() do
        nil -> "1"
        _ -> Dispatches_Warehouse.get_last_id() + 1
      end

    company = Dispatches_Warehouse.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    qty = Breakbulks.list_breakbulk_quantity(item)

    changeset =
      current_user
      |> Ecto.build_assoc(:dispatches_warehouse)
      |> Dispatch_Warehouse.changeset(%{
        "item" => item,
        "total" =>
          String.to_integer(Enum.join([qty])) * Dispatches_Warehouse.get_warehouse_value(),
        "quantity" => String.to_integer(Enum.join([qty])),
        "retailer" => retailer,
        "transporter" => transporter,
        "transporterid" => transporterid,
        "description" => description,
        "active" => active
      })

    qrcode = :qrcode.encode(item)
    png = :qrcode_demo.simple_png_encode(qrcode)
    file = :file.write_file("uploads/warehouse/" <> item <> ".png", png)
    # image = Path.expand("./uploads/warehouse/" <> item <> ".png")
    logo = Path.expand("./priv/static/images/thamani_logo.png")

    value = String.to_integer(Enum.join([qty])) * Dispatches_Warehouse.get_warehouse_value()
    retailer_name = Dispatches_Retailer.get_retailer_name(retailer)
    retailer_owner = Dispatches_Retailer.get_retailer_owner(retailer)
    retailer_email = Dispatches_Retailer.get_retailer_email(retailer)
    html = "<html>
       <head>
       <style>

       .invoice-box {
               max-width: 800px;
               margin: auto;
               padding: 30px;
               border: 1px solid #eee;
               box-shadow: 0 0 10px rgba(0, 0, 0, .15);
               font-size: 16px;
               line-height: 24px;

               color: #555;
           }

           .invoice-box table {
               width: 100%;
               line-height: inherit;
               text-align: left;
           }

           .invoice-box table td {
               padding: 5px;
               vertical-align: top;
           }


           .invoice-box table tr.top table td {
               padding-bottom: 20px;
           }

           .invoice-box table tr.top table td.title {
               font-size: 45px;
               line-height: 45px;
               color: #333;
           }

           .invoice-box table tr.information table td {
               padding-bottom: 40px;
           }

           .invoice-box table tr.heading td {
               background: #eee;
               border-bottom: 1px solid #ddd;
               font-weight: bold;
           }

           .invoice-box table tr.details td {
               padding-bottom: 20px;
           }

           .invoice-box table tr.item td{
               border-bottom: 1px solid #eee;
           }

           .invoice-box table tr.item.last td {
               border-bottom: none;
           }

           .invoice-box table tr.total td:nth-child(5) {
               border-top: 2px solid #eee;
               font-weight: bold;
           }

           @media only screen and (max-width: 600px) {
               .invoice-box table tr.top table td {
                   width: 100%;
                   display: block;
                   text-align: center;
               }

               .invoice-box table tr.information table td {
                   width: 100%;
                   display: block;
                   text-align: center;
               }
           }

           /** RTL **/
           .rtl {
               direction: rtl;

           }

           .rtl table {
               text-align: right;
           }

           .rtl table tr td:nth-child(2) {
               text-align: left;
           }

       </style>
       </head>
       <body>
       <div class='invoice-box'>
        <table cellpadding='0' cellspacing='0'>
            <tr>
                <td colspan='12'>
                    <table>
                        <tr>
                            <td class='title' style=''>
                                <img src ='" <> logo <> "' style='width:100%; max-width:250px;'>
                            </td>

                            <td style='text-align:right;font-size:16px'>
                                <h4>Proforma Invoice #: " <> to_string(last + 1) <> "<br></h4>
                                Created: " <> to_string(DateTime.utc_now()) <> "<br>

                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr class=''>
                <td colspan='12'>
                    <table>
                        <tr>
                             <td style='text-align:left;font-size:16px'>
                                Thamani Online.<br>
                                info@thamanionline.com<br>
                                Nairobi, Kenya
                            </td>

                            <td style='text-align:right;font-size:16px'>
                            Retailer: " <> retailer_name <> ".<br>
                             " <> retailer_owner <> "<br>
                             " <> retailer_email <> "
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>





            <tr class='heading'>
                <td>
                    Item
                </td>
                <td>
                    Description
                </td>
                <td>
                    Qty
                </td>

                <td>
                    Price
                </td>
            </tr>



            <tr class='item '>
                <td>
                    " <> item <> "
                </td>

                <td>
                    " <> description <> "
                </td>
                <td>
                    " <> to_string(qty) <> "
                </td>
                <td>
                    " <> to_string(:erlang.float_to_binary(value, decimals: 2)) <> "
                </td>
            </tr>


            <tr class='total'>
               <td colspan=''>
            <td colspan=''>
            <td colspan='2'>

            <td colspan='2'>
                   <strong>Total: " <> :erlang.float_to_binary(value, decimals: 2) <> "</strong>
                </td>
            </tr>
        </table>
 </div>


       </body>
       </html>"

    file_name = PdfGenerator.generate!(html, page_size: "A4", filename: item)
    pdf_file = File.rename(file_name, "uploads/warehouse/" <> item <> ".pdf")

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "dispatch created successfully.")
        |> redirect(to: dispatch_warehouse_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          file: file,
          pdf_file: pdf_file,
          code: code,
          count_7: count_7,
          count_order: count_order,
          company: company,
          count_stock: count_stock,
          order: "order",
          amount: "amount",
          eta: "eta",
          loader_class: " ",
          message_class: " ",
          alert_class: " ",
          long_process_button_text: " "
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    dispatch__warehouse =
      user
      |> user_dispatch_by_id(id)
      |> Repo.preload(:companies)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if dispatch__warehouse do
      render(
        conn,
        "show.html",
        dispatch__warehouse: dispatch__warehouse,
        count_7: count_7,
        count_order: count_order,
        user: user,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: dispatch_warehouse_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    dispatch__warehouse =
      current_user
      |> user_dispatch_by_id(id)

    bat = Dispatches_Warehouse.get_items(current_user)
    code = Breakbulks.list_breakbulk!(current_user.id)
    company = Dispatches_Warehouse.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    count_order = Warehouse_orders.get_count_order(current_user)

    if dispatch__warehouse do
      changeset = Dispatch_Warehouse.changeset(dispatch__warehouse, %{})

      render(
        conn,
        "edit.html",
        dispatch__warehouse: dispatch__warehouse,
        count_7: count_7,
        code: code,
        count_order: count_order,
        changeset: changeset,
        bat: bat,
        company: company,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: dispatch_warehouse_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "dispatch__warehouse" => %{
            "item" => item,
            "retailer" => retailer,
            "transporter" => transporter,
            "transporterid" => transporterid,
            "description" => description
          }
        },
        current_user
      ) do
    dispatch__warehouse =
      current_user
      |> user_dispatch_by_id(id)

    bat = Dispatches_Warehouse.get_items(current_user)
    code = Breakbulks.list_breakbulk!(current_user.id)
    company = Dispatches_Warehouse.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    qty = Breakbulks.list_breakbulk_quantity(item)

    changeset =
      Dispatch_Warehouse.changeset(dispatch__warehouse, %{
        "item" => item,
        "quantity" => String.to_integer(Enum.join([qty])),
        "total" =>
          String.to_integer(Enum.join([qty])) * Dispatches_Warehouse.get_warehouse_value(),
        "retailer" => retailer,
        "transporter" => transporter,
        "transporterid" => transporterid,
        "description" => description
      })

    qrcode = :qrcode.encode(item)
    png = :qrcode_demo.simple_png_encode(qrcode)
    file = :file.write_file("uploads/warehouse/" <> item <> ".png", png)
    # image = Path.expand("./uploads/warehouse/" <> item <> ".png")
    logo = Path.expand("./priv/static/images/thamani_logo.png")

    value = String.to_integer(Enum.join([qty])) * Dispatches_Warehouse.get_warehouse_value()
    retailer_name = Dispatches_Retailer.get_retailer_name(retailer)
    retailer_owner = Dispatches_Retailer.get_retailer_owner(retailer)
    retailer_email = Dispatches_Retailer.get_retailer_email(retailer)
    html = "<html>
         <head>
         <style>

         .invoice-box {
                 max-width: 800px;
                 margin: auto;
                 padding: 30px;
                 border: 1px solid #eee;
                 box-shadow: 0 0 10px rgba(0, 0, 0, .15);
                 font-size: 16px;
                 line-height: 24px;

                 color: #555;
             }

             .invoice-box table {
                 width: 100%;
                 line-height: inherit;
                 text-align: left;
             }

             .invoice-box table td {
                 padding: 5px;
                 vertical-align: top;
             }


             .invoice-box table tr.top table td {
                 padding-bottom: 20px;
             }

             .invoice-box table tr.top table td.title {
                 font-size: 45px;
                 line-height: 45px;
                 color: #333;
             }

             .invoice-box table tr.information table td {
                 padding-bottom: 40px;
             }

             .invoice-box table tr.heading td {
                 background: #eee;
                 border-bottom: 1px solid #ddd;
                 font-weight: bold;
             }

             .invoice-box table tr.details td {
                 padding-bottom: 20px;
             }

             .invoice-box table tr.item td{
                 border-bottom: 1px solid #eee;
             }

             .invoice-box table tr.item.last td {
                 border-bottom: none;
             }

             .invoice-box table tr.total td:nth-child(5) {
                 border-top: 2px solid #eee;
                 font-weight: bold;
             }

             @media only screen and (max-width: 600px) {
                 .invoice-box table tr.top table td {
                     width: 100%;
                     display: block;
                     text-align: center;
                 }

                 .invoice-box table tr.information table td {
                     width: 100%;
                     display: block;
                     text-align: center;
                 }
             }

             /** RTL **/
             .rtl {
                 direction: rtl;

             }

             .rtl table {
                 text-align: right;
             }

             .rtl table tr td:nth-child(2) {
                 text-align: left;
             }

         </style>
         </head>
         <body>
         <div class='invoice-box'>
          <table cellpadding='0' cellspacing='0'>
              <tr>
                  <td colspan='12'>
                      <table>
                          <tr>
                              <td class='title' style=''>
                                  <img src ='" <> logo <> "' style='width:80%;'>
                              </td>

                              <td style='text-align:right;font-size:16px'>
                                  <h4>Proforma Invoice #: " <> id <> "<br></h4>
                                  Created: " <> to_string(DateTime.utc_now()) <> "<br>

                              </td>
                          </tr>
                      </table>
                  </td>
              </tr>

              <tr class=''>
                  <td colspan='12'>
                      <table>
                          <tr>
                               <td style='text-align:left;font-size:16px'>
                                  Thamani Online.<br>
                                  info@thamanionline.com<br>
                                  Nairobi, Kenya
                              </td>

                              <td style='text-align:right;font-size:16px'>
                              Retailer: " <> retailer_name <> ".<br>
                               " <> retailer_owner <> "<br>
                               " <> retailer_email <> "
                              </td>
                          </tr>
                      </table>
                  </td>
              </tr>





              <tr class='heading'>
                  <td>
                      Item
                  </td>

                  <td>
                      Description
                  </td>
                  <td>
                      Qty
                  </td>

                  <td>
                      Price
                  </td>
              </tr>



              <tr class='item '>
                  <td>
                      " <> item <> "
                  </td>
                  <td>
                      " <> description <> "
                  </td>
                  <td>
                      " <> to_string(qty) <> "
                  </td>
                  <td>
                      " <> :erlang.float_to_binary(value, decimals: 2) <> "
                  </td>
              </tr>


              <tr class='total'>
                 <td colspan=''>
            <td colspan=''>
            <td colspan='2'>

            <td colspan='2'>
                     <strong>Total: " <> :erlang.float_to_binary(value, decimals: 2) <> "</strong>
                  </td>
              </tr>
          </table>
   </div>


         </body>
         </html>"

    file_name = PdfGenerator.generate!(html, page_size: "A4", filename: item)
    pdf_file = File.rename(file_name, "uploads/warehouse/" <> item <> ".pdf")
    # if Dispatches.to_integer(quantity)  <= available do
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "dispatch updated successfully.")
        |> redirect(to: dispatch_warehouse_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          dispatch__warehouse: dispatch__warehouse,
          bat: bat,
          code: code,
          file: file,
          pdf_file: pdf_file,
          changeset: changeset,
          count_7: count_7,
          count_order: count_order,
          company: company,
          count_stock: count_stock
        )
    end

    #    else
    #         conn
    #        |> put_flash(:error, "You have exceeded the quantity limit. Available quantity  is #{available} ")
    #         |> render( "edit.html", changeset: changeset, dispatch__warehouse: dispatch__warehouse,bat: bat, company: company)
    #
    #     end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    dispatch__warehouse =
      user
      |> user_dispatch_by_id(id)

    if current_user.id == dispatch__warehouse.user_id do
      Repo.delete!(dispatch__warehouse)

      conn
      |> put_flash(:info, "dispatch deleted successfully.")
      |> redirect(to: dispatch_warehouse_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this dispatch")
      |> redirect(to: dispatch_warehouse_path(conn, :index))
    end
  end

  defp user_dispatch(user) do
    Ecto.assoc(user, :dispatches_warehouse)
  end

  defp user_dispatch_by_id(user, id) do
    user
    |> user_dispatch
    |> Repo.get(id)
  end
end

