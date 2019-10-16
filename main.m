clc;
clear;
close all;

imgin = im2double(imread('./large1.jpg'));
figure();
imshow(imgin);
[imh, imw, nb] = size(imgin);
assert(nb==1);
% the image is grayscale
k=imh*imw;
V = zeros(k,1);
s1=(imh-2)*(imw-2)*5; %inside points
s2=(imh-2)*6; % row pts
s3=(imh-2)*6;  %col points
sparse_length=s1+s2+s3+4;
s_count=1;
s_i=zeros(1,sparse_length);
s_j=zeros(1,sparse_length);
s_v=zeros(1,sparse_length);
B=zeros(k,1);

now=0;
for i= 1:imh
    for j=1:imw
        
        now=now+1;
        if ((i==1) && (j==1))
            s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=1;
            s_count=s_count+1;
            B(now)=imgin(i,j)-0.5;
        
        elseif (i==1) && (j==imw)
            s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=1;
            s_count=s_count+1;
            B(now)=imgin(i,j)+0.5;
               
        elseif (i==imh) && (j==1)
            s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=1;
            s_count=s_count+1;
            B(now)=imgin(i,j)+0.5;
               
        elseif (i==imh) && (j==imw)
            s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=1;
            s_count=s_count+1;
            B(now)=imgin(i,j)-0.5;
            
        elseif (i==1) || (i== imh)
        	s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=2;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now-1;
            s_v(s_count)=-1;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now+1;
            s_v(s_count)=-1;
            s_count=s_count+1;
            B(now)=2*imgin(i,j) - imgin(i,j-1) - imgin(i,j+1);
            
        elseif (j==1) || (j==imw)
        	s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=2;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now-imw;
            s_v(s_count)=-1;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now+imw;
            s_v(s_count)=-1;
            s_count=s_count+1;
            B(now)=2*imgin(i,j) - imgin(i-1,j) - imgin(i+1,j);
        else
        	s_i(s_count)=now;
            s_j(s_count)=now;
            s_v(s_count)=4;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now-1;
            s_v(s_count)=-1;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now+1;
            s_v(s_count)=-1;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now-imw;
            s_v(s_count)=-1;
            s_count=s_count+1;
            s_i(s_count)=now;
            s_j(s_count)=now+imw;
            s_v(s_count)=-1;
            s_count=s_count+1;
            B(now)=4*imgin(i,j) - imgin(i-1,j) - imgin(i+1,j) - imgin(i,j-1) - imgin(i,j+1);
        end
    end
end
A=sparse(s_i,s_j,s_v);
solution = A\B;
error = sum(abs(A*solution-B));
disp(error)
imgout = transpose(reshape(solution,[imh,imw]));

imwrite(imgout,'left_brighter.png');
figure(), hold off, imshow(imgout);

