defmodule ThamaniWeb.Router do
  use ThamaniWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(JaSerializer.Deserializer)
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:accepts, ["json-api"])
  end

  pipeline :with_session do
    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource)
    plug(ThamaniWeb.CurrentUser)
  end

  pipeline :login_required do
    plug(
      Guardian.Plug.EnsureAuthenticated,
      handler: ThamaniWeb.GuardianErrorHandler
    )

    plug(
      ThamaniWeb.LoginTimeout,
      timeout_after_seconds: 3600
    )
  end

  pipeline :admin_required do
    plug(ThamaniWeb.CheckAdmin)
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/", ThamaniWeb do
    scope "/push" do
      pipe_through([:api])

      get("/:security_key/:user_id", InventoryApiController, :index)
      get("/:security_key/:user_id/:id", InventoryApiController, :show)
      post("/", InventoryApiController, :create)
      delete("/:id", InventoryApiController, :delete)
      put("/:id", InventoryApiController, :update)
    end

    scope "/push_sale" do
      pipe_through([:api])
      get("/:user_id", SaleApiController, :index)
      get("/:user_id/:id", SaleApiController, :show)
      post("/", SaleApiController, :create)
      delete("/:id", SaleApiController, :delete)
      put("/:id", SaleApiController, :update)
    end

    scope "/credit_note" do
      pipe_through([:api])
      get("/:security_key/:user_id", CreditnoteApiController, :index)
      get("/:security_key/:user_id/:id", CreditnoteApiController, :show)
      post("/", CreditnoteApiController, :create)
    end

    scope "/staff/retailer" do
      pipe_through([:api])
      get("/:security_key", StaffApiController, :index)
      get("/:security_key/:phone/:passcode", StaffApiController, :show)
      post("/", StaffApiController, :create)
      delete("/:id", StaffApiController, :delete)
      put("/:id", StaffApiController, :update)
    end

    scope "/device/retailer" do
      pipe_through([:api])
      get("/:security_key", DeviceApiController, :index)
      get("/:security_key/:imei", DeviceApiController, :show)
    end

    scope "/callbacks" do
      pipe_through([:api])

      get("/validate", ValidateApiController, :index)
      post("/validate", ValidateApiController, :create)
      post("/balance", BalanceApiController, :create)
      post("/status", MpesaStatusController, :create)
    end

    scope "/commerce" do
      pipe_through([:api])


      post("/cart", CommerceApiController, :create)
      post("/status", CommerceApiController, :status)
      post("/update", CommerceApiController, :updatecart)
      post("/del", CommerceApiController, :delcart)

    end

    scope "/stkpush" do
      pipe_through([:api])

      get("/validate", MpesaApiController, :index)
      post("/", MpesaApiController, :create)
      get("/validate/:params", MpesaApiController, :show)
    end

    scope "/callbacks" do
      pipe_through([:browser])
      resources("/sms/", SmsApiController)
      resources("/confirmation", ConfirmationController)
    end

    scope "/api/sale_url/v1" do
      pipe_through([:api])
      get("/:security_key", SaleDashboardApiController, :index)
      get("/:security_key/:account_number", SaleDashboardApiController, :show)
      post("/", SaleDashboardApiController, :create)
    end

    pipe_through([:browser, :with_session])

    get("/", PageController, :index)
    get("/privacy", PrivacyController, :index)
    get("/terms", TermsController, :index)
    resources("/register", RegisterController)
    resources("/login", LoginController, only: [:index, :create, :delete])

    resources(
      "/forgot_password",
      ResetController,
      only: [:index, :new, :create, :edit, :update, :delete]
    )

    scope "/" do
      pipe_through([:login_required])

      resources("/validation/", PaymentApiController)
      get("/panel", PanelController, :index)
      resources("/locations", LocationsController)
      resources("/sms_reset/", SmsResetController)
      resources(
        "/users",
        ChangePassController,
        only: [:update]
      )
      resources("/users", UserController)
      resources("/verify", VerifyController)

      # manufacturer panel
      resources("/manufacturer/dashboard/status", ManufacturerDashboardController)
      resources("/item", ItemController)
      resources("/batch", BatchController)
      resources("/manufacturer/dispatch/warehouse", DispatchController)
      resources("/manufacturer/dispatch/retailer", DispatchRetailerController)
      resources("/orders/warehouse/items", OrdersManufacturerController)
      resources("/orders/retail/items", OrdersRetmanController)
      resources("/invoice", InvoiceController)
      resources("/manufacturer/reorders/items", ReorderManufacturerController)
      resources("/manufacturer/sales/status", SalesManufacturerController)
      resources("/manufacturer/warehouse/returns", WreturnController)
      resources("/manufacturer/retailer/returns", RreturnController)
      resources("/manufacturer/warehouse/stock", StockManufacturerController)
      resources("/manufacturer/retailer/stock", StockRetmanController)


      resources "/manufacturer", UserController, only: [:show] do
        resources("/code", CodesController)
        resources("/company", CompanyController)
      end

      # warehouse Panel
      resources("/warehouse/dashboard/status", WarehouseDashboardController)
      resources("/invoice_warehouse", InvoiceWarehouseController)
      resources("/orders", OrdersWarehouseController)
      resources("/warehouse/recieved/items", RecievedController)
      resources("/storage", StorageController)
      resources("/break_bulk", BreakbulkController)
      resources("/warehouse/sales/status", SalesWarehouseController)
      resources("/dispatch", DispatchWarehouseController)
      resources("/manufacturer/order/items", ManufacturerOrdersController)
      resources("/returns", ReturnController)
      resources("/warehouse/reorders/items", ReorderWarehouseController)
      resources("/warehouse/retailer/stock", StockWarehouseController)

      # retailer panel
      resources("/retail/dashboard/status", RetailDashboardController)
      resources("/invoice_retailer", InvoiceRetailController)
      resources("/retailer/sales/status", SaleController)
      resources("/retailer/recieved/manufacturer", RecievedRetmanController)
      resources("/retailer/recieved/warehouse", RecievedRetailerController)
      resources("/inventory", InventoryController)
      resources("/inventory_manufacturer", Inventory2Controller)
      resources("/warehouse/orders/items", WarehouseOrdersController)
      resources("/retailer/orders/items", RetmanOrdersController)
      resources("/warehouse/returns/status", RetailReturnController)
      resources("/retailer/reorder/items", ReorderController)
      resources("/discount", DiscountController)
      resources("/credit_note", NotesController)
      resources("/staff", StaffController)
      resources("/shop", ShopController)
      resources("/device", DeviceController)

      # commerce Dashboard

      resources("/order", CommerceController)
      # get("/completed", CommerceController, :orders)
      resources("/commerce", CommsController)

      get("/completed", CommsController, :orders)

      # sales Dashboard

      resources("/sales/dashboard/status", SaleDashboardController)

      # admin zone GS1 Dashboard
      resources("/admin/thamani/dashboard", Gs1DashboardController)
      resources("/admin/thamani/price_master", PmasterController)
      resources("/admin/thamani/reconciliation", ReconcileController,only: [:index])
      resources("/admin/thamani/mpesa_transactions", MpesaController)

      # admin manufacturer
      resources("/admin/dashboard", ManufacturerAdminDashboardController)
      resources("/admin/item", ItemAdminController)
      resources("/admin/batch", BatchAdminController)
      resources("/admin/barcode", BarcodeController)
      resources("/admin/dispatch", DispatchAdminController)
      resources("/admin/dispatch_retailer/", DispatchRetailerAdminController)
      resources("/admin/warehouse/orders/all", OrdersAdmManufacturerController)
      resources("/admin/retail/orders/all", OrdersAdminRetmanController)
      resources("/admin/sales", SalesAdminManufacturerController)
      resources("/admin/reorder", ReorderAdminController)
      resources("/admin/manufacturer/warehouse/returns", WreturnAdminController)
      resources("/admin/manufacturer/retailer/returns", RreturnAdminController)

      # admin warehouse
      resources("/admin/warehouse/dashboard", WarehouseAdminDashboardController)
      resources("/admin/warehouse/recieved", RecievedAdminController)
      resources("/admin/warehouse/storage", StorageAdminController)
      resources("/admin/warehouse/break_bulk", BreakbulkAdminController)
      resources("/admin/warehouse/dispatch", DispatchAdminWarehouseController)
      resources("/admin/warehouse/manufacturer/orders", ManufacturerAdmOrdersController)
      resources("/admin/warehouse/manufacturer/returns", ReturnAdminController)
      resources("/admin/retailer/orders", OrdersAdmWarehouseController)

      # admin retailer
      resources("/admin/retailer/dashboard", RetailAdminDashboardController)
      resources("/admin/retailer/recieved", RecievedAdminRetailerController)
      resources("/admin/retailer/inventory", InventoryAdminController)
      resources("/admin/retailer/sales", SaleAdminController)
      resources("/admin/retailer/staff", StaffAdminController)
      resources("/admin/manufacturer/orders", RetmanAdminOrdersController)
      resources("/admin/retailer/shop", ShopAdminController)
      resources("/admin/retailer/device", DeviceAdminController)
      resources("/admin/retailer/discount", DiscountAdminController)
      resources("/admin/credit_note", NotesAdminController)
      resources("/admin/retailer/warehouse/orders", WarehouseAdmOrdersController)
      resources("/admin/retailer/returns", RetailAdminReturnController)

      # float panel

      resources("/float/dashboard", FloatDashboardController)
      resources("/float/credit", FloatController)

      resources "/float", UserController, only: [:show] do
        resources("/debit", DebitController)
      end

      # float admin panel
      resources("/admin/float/credit", FloatAdminController)
      resources("/admin/float/debit", DebitAdminController)
      resources("/admin/float/dashboard", FloatAdminDashboardController)

      # admin zone
      scope "/admin", Admin, as: :admin do
        pipe_through([:admin_required])

        resources "/users", UserController, only: [:index, :show] do
        end
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ThamaniWeb do
  #   pipe_through :api
  # end
end
