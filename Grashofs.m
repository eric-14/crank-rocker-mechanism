l_fixed =  input("Enter the length of fixed link ");
l_crank  = input("Enter the length of crank ");
l_coupler = input("Enter the length of the coupler ");
l_follower  = input("Enter the length of the follower ");


a_links = [l_fixed,l_crank,l_coupler,l_follower];

% flag to check for crank rocker 
c_rocker_f = 0;

s = a_links(1);
l = a_links(1);
total_length  = 0 ;
for a = a_links
    if(s > a)
        s = a;
    end
    if(l < a)
        l = a;
    end
    total_length = total_length + a;
end
p_and_q = total_length  - (s+l);

if((s + l) <= p_and_q)
    disp("There is revolution of at least one bar")
    if(a_links(1) == a_links(3) && a_links(2) == a_links(4) )
        disp("Parallel rank mechanism")
    elseif(s == a_links(1))
        disp("Drag link mechanism")
    elseif(s == a_links(2) || s == a_links(4))
        c_rocker_f = 1;
        disp("Crank_rocker mechanism")
    end
else
    disp("There is no revolution,  DOUBLE ROCKER")
end

CR_len = [50,200,150,205];
prompt2 = "Enter angular velocity ";
prompt3 = "Enter angular acceleration ";
teta2_v = input(prompt2);
teta2_a = input(prompt3);

teta3_disp = [];  %displacement at teta3
teta4_disp = [];  %displacement at teta4

teta2_t = [];
teta3_vel = []; % velocity at teta3
teta4_vel = []; %velocity at teta4

teta3_acc = [];
teta4_acc = [];


if (teta2_v ~= 0 &&  c_rocker_f == 1)
     
    
    % The relationship equation for the mechanism changes after 180degrees 
    for teta2 = 0:5:180
        l = sqrt( (l_crank ^ 2 + l_fixed ^ 2 - 2 * l_crank * l_fixed * cosd(teta2)) ); % l is the length of the diagonal of the mechanism. derived from cosindes laws
        beta = acosd((l ^ 2 + l_coupler ^ 2 - l_follower ^ 2) / (2 * l * l_fixed)); % angle formed btw fixed link and diagonal
        
        lambda = acosd( ((l ^ 2 + l_follower ^ 2 - l_coupler ^ 2) / (2 * l * l_follower)) );
        
        phi = acosd( (l ^ 2 + l_coupler ^ 2 - l_follower ^ 2) / (2 * l * l_coupler));

        teta3 = phi - beta;
        teta4 = 180 - (lambda + beta);

        teta3_v = l_crank / l_coupler * teta2_v * sind(teta4 - teta2) / sind(teta3 - teta4 );
        teta4_v = l_crank / l_follower * teta2_v * sind(teta3 - teta2) / sind(teta3 - teta4);
        
        teta3_a = round( (l_crank * (teta2_v ^ 2) * cosd(teta4 - teta2) + l_coupler * (teta3_v ^ 2) * cos(teta4 - teta3) - l_follower * teta4_v ^ 2) / (l_coupler * sind(teta4 - teta3)),6);
        teta4_a =round( ( - l_crank * (teta2_v ^ 2) * cosd(teta3 - teta2) + l_follower * (teta4_v ^ 2) * cos(teta3 - teta4) - l_coupler * teta3_v ^ 2) / (l_follower * sind(teta3 - teta4)),6);
        teta2_t(end+1) = teta2;
        teta3_disp(end+1) = teta3;
        teta4_disp(end+1) = teta4;

        teta3_vel(end+1) = teta3_v;
        teta4_vel(end+1) = teta4_v;

        teta3_acc(end+1) = teta3_a;
        teta4_acc(end+1) = teta4_a ;       
    end
% 
    for teta2 = 180:5:360
        l = sqrt( (l_crank ^ 2 + l_fixed ^ 2 - 2 * l_crank * l_fixed * cosd(teta2)) ); % l is the length of the diagonal of the mechanism. derived from cosindes laws
        beta = acosd((l ^ 2 + l_coupler ^ 2 - l_follower ^ 2) / (2 * l * l_fixed)); % angle formed btw fixed link and diagonal
        
        phi = acosd((l ^ 2 + l_coupler ^ 2 - l_follower ^ 2) / (2 * l * l_coupler));
        
        lambda = acosd( ((l ^ 2 + l_follower ^ 2 - l_coupler ^ 2) / (2 * l * l_follower)) );
        
        teta3 = phi + beta;
        teta4 = 180 - (lambda - beta);

        teta3_v = l_crank / l_coupler * teta2_v * sind(teta4 - teta2) / sind(teta3 - teta4);
        teta4_v = l_crank / l_follower * teta2_v * sind(teta3 - teta2) / sind(teta3 - teta4);
        
        
        teta3_a = round( (l_crank * (teta2_v ^ 2) * cosd(teta4 - teta2) + l_coupler * (teta3_v ^ 2) * cos(teta4 - teta3) - l_follower * teta4_v ^ 2) / (l_coupler * sind(teta4 - teta3)),6);
        teta4_a =round( ( - l_crank * (teta2_v ^ 2) * cosd(teta3 - teta2) + l_follower * (teta4_v ^ 2) * cos(teta3 - teta4) - l_coupler * teta3_v ^ 2) / (l_follower * sind(teta3 - teta4)),6);
        
        teta2_t(end+1) = teta2;
        teta3_disp(end+1) = teta3;
        teta4_disp(end+1) = teta4;

        teta4_vel(end+1) = teta4_v;
        teta3_vel(end+1) = teta3_v;

        teta3_acc(end+1) = teta3_a;
        teta4_acc(end+1) = teta4_a;
    

    end 
    
      figure(1)
      subplot(3,1,1);
      plot(teta2_t,teta3_disp),xlabel('teta 2'), ylabel("teta3")
      title('1')
      
      subplot(3,1,2);
      plot(teta2_t,teta3_acc),xlabel('teta 2'), ylabel("teta 3 acceleration")
      
      subplot(3,1,3);
      plot(teta2_t,teta3_vel),xlabel('teta 2'), ylabel("teta 3 velocity")
      
      figure(2)
      subplot(3,1,1);
      plot(teta2_t,teta4_disp),xlabel('teta 2'), ylabel("teta 4")
      
      subplot(3,1,2);
      plot(teta2_t,teta4_acc),xlabel('teta 2'), ylabel("teta 4 acc")
      
      subplot(3,1,3);
      plot(teta2_t,teta3_vel),xlabel('teta 2'), ylabel("teta 4 vel");
  

end 

 

