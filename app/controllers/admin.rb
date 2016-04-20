get "/admin/index" do
	# unless sessions[:user_id]
	# end
	erb :admin_index, layout: :layout_admin
end
