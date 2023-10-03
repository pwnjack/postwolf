# PostWolf

This bad boy is your one-stop shop for gathering intel on a Linux box. Perfect for those late-night pentesting parties or when you're auditing your system's security.

## What's in the Box?

- Sniffs out system info like kernel version, IP addresses, routing tables, open ports, running processes, installed packages, and more. It's like a digital bloodhound.
- Gets the lowdown on users and groups.
- Lists all the system services that are up and running.
- Encrypts the juicy data using AES-256. We're not leaving any traces, are we?
- Exfiltrates the encrypted data to a location of your choice using SCP, curl, or netcat. Like a digital ninja.

## How to Roll

1. Tweak the `password`, `user`, `your_ip`, and `your_port` variables at the top of the script. Make it your own.
2. Unleash the script on the target system.
3. Sit back and watch as it creates a directory, gathers info, encrypts the data, and exfiltrates it to your chosen location.
4. Once the job's done, it cleans up the scene by removing the directory and any files it created. No fingerprints, no evidence.

## Word of Caution

Remember, with great power comes great responsibility. Use this script wisely and ethically. Unauthorized access and data gathering is not just uncool, it's illegal. Always have permission before you go snooping around.