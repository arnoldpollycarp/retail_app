defmodule ThamaniWeb.InputHelpers do
  use Phoenix.HTML
  alias Thamani.Dispatches

  def array_input(form, field, attr \\ []) do
    default_attr = [
      count: 1
    ]

    merged_attr = attr ++ default_attr
    count = merged_attr[:count]
    values = Phoenix.HTML.Form.input_value(form, field) || []

    values =
      if Enum.count(values) >= count,
        do: values,
        else: List.duplicate("", count - Enum.count(values)) ++ values

    id = Phoenix.HTML.Form.input_id(form, field)

    content_tag :div,
      id: container_id(id),
      class: "input_container",
      data: [index: Enum.count(values)] do
      values
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        form_elements(form, field, value, index)
      end)
    end
  end

  def array_select(form, field, attr \\ [], conn) do
    default_attr = [
      count: 1
    ]

    merged_attr = attr ++ default_attr
    count = merged_attr[:count]
    values = Phoenix.HTML.Form.input_value(form, field) || []

    values =
      if Enum.count(values) >= count,
        do: values,
        else: List.duplicate("", count - Enum.count(values)) ++ values

    id = Phoenix.HTML.Form.input_id(form, field)
    type = Phoenix.HTML.Form.input_type(form, field)

    content_tag :div,
      id: container_id(id),
      class: "control-label",
      data: [index: Enum.count(values)] do
      values
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        new_id = id <> "_#{index}"

        input_opts = [
          name: new_field_name(form, field),
          value: value,
          id: new_id
        ]

        select_elements(form, field, value, index, conn)
      end)
    end
  end

  def array_add_button(form, field) do
    id = Phoenix.HTML.Form.input_id(form, field)

    content =
      form_elements(form, field, "", "__name__")
      |> safe_to_string

    data = [
      prototype: content,
      container: container_id(id)
    ]

    link("Add", to: "#", data: data, class: " add-form-field fa fa-plus btn btn-gold btn-round")
  end

  def array_select_add_button(form, field, conn) do
    id = Phoenix.HTML.Form.input_id(form, field)

    content =
      select_elements(form, field, "", "__name__", conn)
      |> safe_to_string

    data = [
      prototype: content,
      container: container_id(id)
    ]

    link("Add", to: "#", data: data, class: " add-form-field fa fa-plus btn btn-gold btn-round")
  end

  defp form_elements(form, field, value, index) do
    type = Phoenix.HTML.Form.input_type(form, field)
    id = Phoenix.HTML.Form.input_id(form, field)
    new_id = id <> "_#{index}"

    input_opts = [
      name: new_field_name(form, field),
      value: value,
      id: new_id,
      class: "form-control "
    ]

    content_tag :div, style: "padding-top: 15px;padding-bottom: 15px;" do
      [
        apply(Phoenix.HTML.Form, type, [form, field, input_opts]),
        link(
          "",
          to: "#",
          data: [id: new_id],
          title: "Remove",
          class: " remove-form-field fa fa-close",
          style: "color:#f44336 !important;float: right;margin-top: -20px;margin-right: -10px;"
        )
      ]
    end
  end

  def select_elements(form, field, value, index, conn) do
    type = Phoenix.HTML.Form.input_type(form, field)
    id = Phoenix.HTML.Form.input_id(form, field)
    new_id = id <> "_#{index}"

    current_user = Guardian.Plug.current_resource(conn)
    items = Dispatches.get_recieved_select(current_user.id)

    input_opt = [
      name: new_field_name(form, field),
      value: value,
      id: new_id,
      class: "dropdown-toggle bs-placeholder btn btn-gold btn-round  single_select",
      style: "font-size: 13px;margin-top: -10px;width:100%;"
    ]

    content_tag :div, style: "padding-top: 30px;padding-bottom: 15px;" do
      [
        apply(Phoenix.HTML.Form, :select, [form, field, items, input_opt]),
        link(
          "",
          to: "#",
          data: [id: new_id],
          title: "Remove",
          class: " remove-form-field fa fa-close",
          style: "color:#f44336 !important;float: right;margin-top: 5px;margin-right: -50px;"
        )
      ]
    end
  end

  defp container_id(id), do: id <> "_container"

  defp new_field_name(form, field) do
    Phoenix.HTML.Form.input_name(form, field) <> "[]"
  end
end
