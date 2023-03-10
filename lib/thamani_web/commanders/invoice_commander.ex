defmodule ThamaniWeb.InvoiceCommander do
  use Drab.Commander

  alias Thamani.Sales
  alias Thamani.Invoicing
  alias Thamani.Dispatches

  access_session(:drab_test)

  defhandler fetch_list(socket, sender) do
    poke(socket, long_process_button_text: "", date: "", date_1: "")
    mid = String.to_integer(sender.params["current_user"])

    date = to_string(sender.params["date"])
    date_1 = to_string(sender.params["date_1"])
    list_sales = Sales.list_sales_manufacturer_invoice(mid, date, date_1)
    list_sales_uniq = Sales.list_sales_manufacturer_invoice_uniq(mid, date, date_1)
    count_sales = Sales.count_sales_manufacturer_invoice(mid, date, date_1)
    sum_sales =
      case Sales.sum_sales_price_manufacturer_invoice(mid, date, date_1) do
        nil -> 0
        _ -> Sales.sum_sales_price_manufacturer_invoice(mid, date, date_1)
      end
    poke(socket, loader_class: "loader-show")

    poke(socket,
      # list_sales: list_sales,
      list_sales_uniq: list_sales_uniq,
      count_sales: count_sales,
      date_0: date,
      date_01: date_1,
      sum_sales: sum_sales
    )

    poke(socket, loader_class: "loader-hide")
  end

  defhandler generate_invoice(socket, sender) do
    poke(socket, loader_class: "loader-hide")
    mid = String.to_integer(sender.params["current_user"])
    date = to_string(sender.params["date_0"])
    date_1 = to_string(sender.params["date_01"])
    list_sales = Sales.list_sales_manufacturer_invoice(mid, date, date_1)
    list_sales_uniq = Sales.list_sales_manufacturer_invoice_uniq(mid, date, date_1)
    value = (Sales.sum_sales_price_manufacturer_invoice(mid, date, date_1))
    items = sender.params["count_sales"]
    vat = :erlang.float_to_binary(value * 16 / 116, decimals: 2)
    exclusive = :erlang.float_to_binary(value * 100 / 116, decimals: 2)

    last =
      case Invoicing.get_last_id() do
        nil -> "1"
        _ -> to_string(Invoicing.get_last_id() + 1)
      end

    invoice_number = "tho_" <> last

    qrcode = :qrcode.encode(invoice_number)
    png = :qrcode_demo.simple_png_encode(qrcode)
    # file = :file.write_file("uploads/invoice/" <> invoice_number <> ".png", png)
    # image = Path.expand("./uploads/invoice/" <> invoice_number <> ".png")
    logo = Path.expand("./priv/static/images/thamani_logo.png")
    manufacturer_name = Dispatches.get_warehouse_name(mid)
    manufacturer_owner = Dispatches.get_warehouse_owner(mid)
    manufacturer_email = Dispatches.get_warehouse_email(mid)

    poke(socket, message_class: "alert alert-warning")
    poke(socket, long_process_button_text: "Generating invoice in a few seconds")

    poke(socket, loader_class2: "loader-show")

    html =
      "<html>
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

          .invoice-box table tr td:nth-child(2) {
              text-align: right;
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

          .invoice-box table tr.total td:nth-child(2) {
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
                           <img src ='" <>
        logo <>
        "' style='width:100%; max-width:250px;'>
                       </td>

                       <td style='text-align:right;font-size:16px'>
                           <h4>Invoice #: " <>
        "#tho" <>
        last <>
        "<br></h4>
                           Created: " <>
        to_string(Date.utc_today()) <>
        "<br>

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
                       Manufacturer: " <>
        manufacturer_name <>
        ".<br>
                        " <>
        manufacturer_owner <>
        "<br>
                        " <>
        manufacturer_email <>
        "
                       </td>
                       <td style='text-align:right;font-size:16px'>
                          Thamani Online.<br>
                          info@thamanionline.com<br>
                          Nairobi, Kenya
                      </td>
                   </tr>
               </table>
           </td>
       </tr>





       <tr class='heading'>
             <td data-field='name' >Item</td>
             <td  style='text-align:center' >quantity</td>
             <td data-field='uprice' >Unit Price</td>
             <td data-field='tprice' >Total Price</td>

       </tr>


      #{
          for sale <- list_sales_uniq do
            "
      <tr class='items'>
       <td> " <> Sales.get_name_sale_uniq(sale) <> " </td>
       <td style='text-align:center'> " <> to_string(Sales.get_quantity_sale_uniq_man(mid,sale,date,date_1)) <> "  </td>
       <td>"<> to_string(Sales.get_price_sale_uniq_man(sale) )<>"</td>
      <td>"<> to_string(Sales.get_price_sale_uniq_man(mid,sale,date,date_1)) <>"</td>

       </tr>

       "
          end
        }

<tr class='items'>
           <td></td>
           <td></td>
	        <td></td>
           <td  style='text-align:left'> <strong>Sub Total:</strong>
              <strong>" <> (exclusive) <> "</strong>
           </td>
       </tr>
       <tr class='items'>
           <td></td>
           <td></td>
            <td></td>
           <td  style='text-align:left'>  <strong>Total VAT:</strong>
              <strong>" <> (vat) <> "</strong>
           </td>
       </tr>
       <tr class='heading'>
           <td></td>
           <td></td>
           <td></td>
           <td  style='text-align:left'> <strong>Total:</strong>
              <strong> " <> :erlang.float_to_binary(value, decimals: 2) <> "</strong>
           </td>
       </tr>
       </table>
</div>


      </body>
      </html>"

    Invoicing.create_invoice_node(invoice_number, String.to_integer(items), mid)

    file_name = PdfGenerator.generate!(html, page_size: "A4", filename: invoice_number)
    pdf_file = File.rename(file_name, "uploads/invoice/" <> invoice_number <> ".pdf")
    poke(socket, loader_class2: "loader-hide")

    poke(
      socket,
      message_class: "alert alert-success",
      long_process_button_text: "Invoice has been generated succesfully "
    )
  end
end
