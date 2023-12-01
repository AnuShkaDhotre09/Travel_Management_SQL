create database travel_management;
use travel_management;



---table Employee
create table tbl_employye(emp_id int primary key identity(1,1),
emp_fname varchar(255),emp_lname varchar(255),emp_address varchar(255),emp_contact bigint,emp_dob date);




--storted procedure

--add
create or alter procedure employye_add (@fn varchar(255),@ln varchar(255),@addr varchar(255),@con BigInt,@dob date)
as
begin
insert into tbl_employye values(@fn,@ln,@addr,@con,@dob)
end;

exec employye_add 'Piyusha','Dhotre',
'Ichlkaranji',8308090246,'07-05-2001';
select * from tbl_employye;

--view

create or alter procedure employye_View
as
begin
select *from tbl_employye

end;

exec employye_View ;

---edit

create or alter procedure employye_edit(@id int,@fn varchar(255),@ln varchar(255))
as
begin
update tbl_employye set emp_address='Mumbai' where emp_id=1; 
end;


exec employye_edit 1,'Anushka','Dhotre';
select * from tbl_employye;


--delete
create or alter procedure employye_Delete(@id int)
as
begin
Delete from tbl_employye
where emp_id=@id
end;

exec employye_Delete 1;



---table travel request


create table tabl_travel_request(req_id  int primary key identity(1,1),
location_from varchar(255),location_to varchar(255),approved_status varchar(255),
booking_status varchar(255),current_status varchar(255),
emp_id int, foreign key(req_id) references tbl_employye(emp_id));


select * from tabl_travel_request;


--storted procedure

--add

create or alter procedure travel_add(@lf varchar(255),@lt varchar(255),@Ap varchar(255),@Bs varchar(255),@Cs varchar(255),@e_id int)
as
begin
insert into tabl_travel_request values(@lf,@lt,@Ap,@Bs,@Cs,@e_id);
end;

exec travel_add 'Kolhapur','Pune','Approve','Yes','open',7;
exec travel_add 'Mumbai','Pune','Not Approve','Yes','open',11;
exec travel_add 'Kolkatta','Pune','Approve','Yes','open',3;

select * from tabl_travel_request;


--delete
create or alter procedure travel_delete(@r_id int)
as
begin
delete from tabl_travel_request where req_id=@r_id
end;

exec travel_delete 1;


--view
create or alter procedure travel_view 
as
begin
select * from  tabl_travel_request 
end;

exec travel_view ;


--update
create or alter procedure travel_edit(@r_id int,@lf varchar(255),@lt varchar(255),@Ap varchar(255))
as
begin
update tabl_travel_request set current_status='Not Approved' where req_id=1;
end;

exec travel_edit 7,'Kolhapur','Pune','Yes';

select * from tabl_travel_request;


---approve
create or alter procedure approve_travel
as
begin
select approved_status from tabl_travel_request
end;

exec approve_travel;

--approve edit
create or alter procedure approve_travel_edit (@r_id int,@as varchar(255))
as 
begin
update tabl_travel_request set approved_status=@as,current_status='closed' where req_id=@r_id
end
else
begin
update tabl_travel_request set approved_status=@as  where req_id=@r_id
end
end

exec approve_travel_edit 7,'not approved';
select * from tabl_travel_request;




--booking
create or alter procedure booking_travel
as
begin
select booking_status from tabl_travel_request
end;

exec booking_travel;



--booking confirm
create or alter procedure booking_travel_edit
as
begin
update tabl_travel_request set booking_status='No' where req_id=1
end;

exec booking_travel_edit;
select * from tabl_travel_request;


---current

create or alter procedure current_travel
as
begin
select current_status from tabl_travel_request
end;

exec current_travel;



--current edit
create or alter procedure current_travel_edit
as
begin
update tabl_travel_request set current_status='Not Approved' where req_id=7
end;

exec current_travel_edit;
select * from tabl_travel_request;


--ApproveRequest - To Update the Approved_Status column for Request
create or Alter procedure sp_ApproveRequest (@req_id int, @is_approved varchar(15))
as 
begin
	if @is_approved='Not Approved'
	begin
		update tabl_travel_request set approved_status=@is_approved, current_status='Closed'
		where req_id=@req_id
	end
	else
	begin
		update tabl_travel_request set approved_status=@is_approved
		where req_id=@req_id
	end
end

exec sp_ApproveRequest 6, 'Not Approved' 

select * from tabl_travel_request


--ConfirmBooking
create or alter procedure sp_ConfirmBooking (@req_id int, @booking_status varchar(15))
as
begin
	update tabl_travel_request set booking_status=@booking_status, Current_Status='Closed' 
	where req_id=@req_id
end

exec sp_ConfirmBooking 4,' Not Available'



--ViewAllRequests
create procedure sp_ViewAllRequests
as
begin
	select req_id, e.emp_id,  location_from, location_to, approved_status, Booking_Status, 
	current_status, e.emp_fname 
	from tbl_employye e inner join tabl_travel_request t
	on e.emp_id=t.emp_id
	order by req_id
end

exec sp_ViewAllRequests


--ViewOpenRequests
create procedure sp_ViewOpenRequests
as
begin
	select req_id, e.emp_id,  Location_from, Location_to, approved_status, booking_status, 
	current_status
	from  tbl_employye e inner join  tabl_travel_request t
	on e.emp_id=t.emp_id
	where current_status='Open' and approved_status is null
	order by emp_id
end

exec sp_ViewOpenRequests




--ViewApprovedRequests
create procedure sp_ViewApprovedRequests
as
begin
	select REq_id, e.emp_id,  location_from, location_to, Approved_Status, Booking_Status, 
	Current_Status
	from  tbl_employye e inner join  tabl_travel_request t
	on e.emp_Id=t.emp_id
	where Current_Status='Open' and approved_status ='Approved'
	order by emp_id
end

exec sp_ViewApprovedRequests
