function setup_email(acc_info)

    % setup_email sets up the email account for sending msg from MATLAB
    %   Input arguments:
    %     acc_info: a struct with email account information. It has follow
    %               fields: smtp_server, email_acc_name, smtp_username,
    %               password.

    setpref('Internet','SMTP_Server',acc_info.smtp_server);
    setpref('Internet','E_mail',acc_info.email_acc_name);
    setpref('Internet','SMTP_Username',acc_info.smtp_username);
    setpref('Internet','SMTP_Password',acc_info.password);
    
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class',...
                      'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');

end




