delimiter **
create trigger tri_vendas_ai
after insert on  comivenda
for each row
begin
    set vtotal_item = new.n_vlvenda * new.n_qvenda;
	update comivenda set n_totavenda = vtotal_itens - vtotal_item
	where n_numevenda = new.n_numevenda;
end **

    declare vtotal_itens float(10,2) default 0;
	declare vtotal_item float(10,2) default 0;
	declare total_item float(10,2);
    declare q_item int default 0;
    declare endloop int default 0;
	
    declare busca_itens cursor for
		select n_vlvenda, n_qvenda
		from comivenda
		where n_numevenda = new.n_numevenda;
	declare continue handler for sqlstate '02000' set endloop = 1;
	
    open busca_itens;
		itens : loop
		
			if end_loop = 1 then
				leave itens;
			end if;
	
			fetch busca_itens into total_item, q_item;
			
			set vtotal_item = total_item * q_item;
			set vtotal_itens = vtotal_itens + vtotal_item;
            
	end loop itens;
    delimiter ;
