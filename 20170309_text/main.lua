local n, i, tot, a = 2015, 1, 0, 0

while n > 0 do
	if n % 10 == 2 then
		tot = tot + (n / 10) * i + a + 1
	elseif n % 10 > 2 then
		tot = tot + (n / 10 + 1) * i
	else
		tot = tot + (n / 10) * i
	end

	a = a + i*(n % 10)
	i = i * 10
	n = int(n / 10)
end

print(tot)