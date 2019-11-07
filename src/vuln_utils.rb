def system_info(url)
	xml_response = do_request(url, '/glpi/config')
	address = get_element(xml_response, 'address')
	puts 'Server: '.red << address.split[0]
	puts 'SO: '.red << address.split[1]

	glpi_version = do_request(url, '/glpi/CHANGELOG.md')
	glpi_version = get_element(glpi_version, '//p').to_s.split("\n\n").grep(/unreleased$/).to_s.split[1]
	puts 'GLPI version: '.red << glpi_version
end

def dir_testing(url)
	xml_response = do_request(url, '/glpi/config')
	xml_response = get_element(xml_response, 'title')

	if (xml_response == "Index of /glpi/config")
		puts " [-] ".red.bold << "Directory List"
		puts "  [+] ".red << "Interesting folders"
		puts "   [+] ".red <<  "/glpi/files/_dumps > Database dump"
		puts "   [+] ".red <<  "/glpi/files/_sessions"
		puts "   [+] ".red <<  "/glpi/files/_uploads"
	else
		puts "No directory Listing"
	end
end

def sensitive_files(url)
	response = Net::HTTP.get_response("#{url}", '/glpi/files/_log/event.log')
	puts " [-]".red.bold  << " The file is available" if (response.code == "200")
end
