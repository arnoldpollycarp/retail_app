defmodule ThamaniWeb.StaffApiView do
  use ThamaniWeb, :view

  def render("index.json", %{staffs: staffs}) do
    %{data: render_many(staffs, ThamaniWeb.StaffApiView, "staff.json")}
  end

  def render("show.json", %{staff: staff}) do
    %{data: render_one(staff, ThamaniWeb.StaffApiView, "staff.json")}
  end

  def render("staff.json", %{staff_api: staff_api}) do
    %{
      id: staff_api.id,
      fullname: staff_api.fullname,
      phone: staff_api.phone,
      passcode: staff_api.passcode,
      description: staff_api.description,
      active: staff_api.active,
      Retailer: staff_api.user.company,
      user_id: staff_api.user_id,
      shop: staff_api.shops.name
    }
  end
end
