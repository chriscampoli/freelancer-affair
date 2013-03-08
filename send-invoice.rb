#!/usr/bin/env ruby
#A Freelancer Affair
puts "Welcome to a Freelancer Affair\n\n"

path_people = 'people/'
path_invoices = 'invoices/'
pattern = /^full Name: (?<name>\w.*).VAT ID: (?<vat>\w.*)$/im

ARGV.each_with_index do|a, i|
  case i
    when 0
      if File.exist?(path_people + a)
        $freelancer =  pattern.match(File.read(path_people + a ))
      else
        abort("Freelancer #{a} does not exist.")
      end
    when 1
      if File.exist?(path_people + a)
        if a == "fabio-salvo.txt"
          puts "This client is a shit\n"
        end
        $client =  pattern.match(File.read(path_people + a ))
      else
        abort("Client #{a} does not exist.")
      end
    when 2
      if a.to_i > 0
        $amount = a
      else
        abort("Please insert a positive amount of money, don't be a Salvo")
      end 
  end
end
file_name =  Time.now.strftime('%Y%m%d')+"-"+$freelancer['name'].gsub(/ /, '-').downcase+"-"+$client['name'].gsub(/ /, '-').downcase+'.txt'
if File.exist?(path_invoices + file_name)
  abort("This invoices has already been sent!")
else
  template_file = 'template.txt'
  if File.exist?(path_invoices + template_file)
    invoice = File.read(path_invoices + template_file )
  else
    abort("Couldn't find invoice's template file")
  end
  puts invoice.inspect
  replacements = [ 
    ["<amount>", $amount], 
    ["<client_name>", $client['name'].strip], 
    ["<client_vat>", $client['vat'].strip], 
    ["<freelancer_name>", $freelancer['name'].strip], 
    ["<freelancer_vat>", $freelancer['vat'].strip],
    ["<weekday>", Time.now.strftime('%A')] 
  ]
  replacements.each {|replacement| invoice.gsub!(replacement[0], replacement[1])}
  finvoice = File.new(path_invoices + file_name, "w")
  finvoice.write(invoice)
  finvoice.close
end
