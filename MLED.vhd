
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--// PROJET VHDL MARS 2019
--//Programmeurs: Benjamin Tan et Noor Kardache																																																									  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Intégration des bibliothèques

library ieee;																									--La bibliothèques ieee est nécessaire car il contient les définitions de bases
use ieee.std_logic_1164.all;																				--Il apporte des systèmes logique de multiples niveaux ex: 8 et 9

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Création d'une entité MLED (Moving Light Emitting Diode)

entity MLED is																									--En entrée nous avons une horloge et des interrupteurs 
port ( horloge, interr1, interr3, interr4, interr5, interr6: in std_logic; LEDX: out std_logic_vector(9 downto 0));			--et en sortie un vecteur de 10 éléments (nos 10 LED)
end MLED;																										--Fin déclaration des entrées et sorties de l'entité MLED

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
architecture comportement of MLED is
type machine_etat is (LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8, LED9, LED10);		--On crée un type machine_etat qui servira a changer les états des LED 1 à 10
signal mon_etat: machine_etat;																			--On dit que mon_etat est un signal de type machine_etat ce dernier attribut un état à une LED
signal compteurun: integer range 0 to 1000000:=0;													--compteurun est un entier qui sert a choisir un moment pour réaliser les conditions de changement d'état
signal compteurdeux: integer range 0 to 30:=0;														--compteurdeux est un entier pour réaliser les conditions du sens de déplacement des changement des états

begin																												--Début du comportement de mon entité composé de 2 processus (ils s'éxecutent parallèlement) 

	--Processus séquentiel
	
	Firstprocess: process(horloge)																		--Début premier processus avec l'horloge dans la liste de sensibilité
	begin
		if horloge'event and horloge = '1' then														--Si mon horloge recommence son cylce,		(1)
		
			if compteurun = 709854 then																	--Et si le compteurun est égal à ....		(2) 
			
				compteurdeux<=compteurdeux+1;																--Alors j'incrémente mon deuxième compteur
				
				if (compteurdeux<11) then																	--Et si le compteurdeux est plus petit que 11 (si je fais mon allée) alors		(3)
					case mon_etat is 																			--Début switch case, définitions de 10 cas pour mon signal mon_etat
						when LED1 => mon_etat <= LED2;													--Soit quand mon_etat aura l'état de LED1, alors mon_etat recevra l'etat de ma LED2
						when LED2 => mon_etat <= LED3;													--Et ainsi de suite
						when LED3 => mon_etat <= LED4;
						when LED4 => mon_etat <= LED5;
						when LED5 => mon_etat <= LED6;
						when LED6 => mon_etat <= LED7;
						when LED7 => mon_etat <= LED8;
						when LED8 => mon_etat <= LED9;
						when LED9 => mon_etat <= LED10;
						when LED10 => mon_etat <= LED10;													--mon_etat reste à celui de la LED10
					end case;
					
				elsif (compteurdeux>10 and compteurdeux<20) then									--Autre condition si mon compteur est entre 10 et 20
					case mon_etat is 																			--Alors on fait le changement inverse
						when LED10 => mon_etat <= LED9;
						when LED9 => mon_etat <= LED8;
						when LED8 => mon_etat <= LED7;
						when LED7 => mon_etat <= LED6;
						when LED6 => mon_etat <= LED5;
						when LED5 => mon_etat <= LED4;
						when LED4 => mon_etat <= LED3;
						when LED3 => mon_etat <= LED2;
						when LED2 => mon_etat <= LED1;
						when LED1 => mon_etat <= LED1;													--mon_etat reste à celui de la LED1
					end case;
					
				else
					compteurdeux<=0;																			--Sinon on réinitialise le compteurdeux
					
				end if;																							--Fin condition si (3)
				
				compteurun<=0;																					--Autre cas on réinitialise le compteurun
				
			else
				compteurun<= compteurun+1;																	--Sinon on incrémente le compteurun
				
			end if;																								--Fin condition si (2)
			
		end if;																									--Fin condition si (1)			
	end process;																								--Fin du premier processus séquentiel synchrone
	
	
	--Processus séquentiel mais qui
	--s’exécute en même temps que le premier
	
	Secondprocess: process(mon_etat)																		--Début du deuxième processus pour l'application des changements
	begin
	
	if interr1='0' then																						--Si mon interrupteur1 est éteint on alors réalise le premier cas
	 case mon_etat is 
		 when LED1=>LEDX<="0000000001";																	--Quand l'état mon_etat correspond à celle de ma LED1 alors on allume la LED1
		 when LED2=>LEDX<="0000000010";																	--Et ainsi de suite...
		 when LED3=>LEDX<="0000000100";
		 when LED4=>LEDX<="0000001000";
		 when LED5=>LEDX<="0000010000";
		 when LED6=>LEDX<="0000100000";
		 when LED7=>LEDX<="0001000000";
		 when LED8=>LEDX<="0010000000";
		 when LED9=>LEDX<="0100000000";
		 when LED10=>LEDX<="1000000000";
	 end case;																									--Fin du premier cas
	 
	 else																											--Si mon interrupteur1 est allumé alors on realise le cas ci-dessous
		 case mon_etat is 																					--Bonus car on n'a pas pu réaliser le traîné d'intensité avec le pwm...
			 when LED1=>LEDX<="1000000001";
			 when LED2=>LEDX<="0100000010";
			 when LED3=>LEDX<="0010000100";
			 when LED4=>LEDX<="0001001000";
			 when LED5=>LEDX<="0000110000";
			 when LED6=>LEDX<="0001111000";
			 when LED7=>LEDX<="0001111000";
			 when LED8=>LEDX<="0011111100";
			 when LED9=>LEDX<="0111001110";
			 when LED10=>LEDX<="1110000111";
		 end case;
	 
	 end if;
	 	if interr3='1' then	
			case mon_etat is	
			 when led1=>LEDX<="0000000001";
			 when led2=>LEDX<="0000000011";
			 when led3=>LEDX<="0000000111";
			 when led4=>LEDX<="0000001111";
			 when led5=>LEDX<="0000011111";
			 when led6=>LEDX<="0000111111";
			 when led7=>LEDX<="0001111111";
			 when led8=>LEDX<="0011111111";
			 when led9=>LEDX<="1111111111";
			 when led10=>LEDX<="1111111111";
		 end case;
	 end if;
	 	if interr4='1' then	
			case mon_etat is	
			 when led1=>LEDX<="0000110000";
			 when led2=>LEDX<="0001111000";
			 when led3=>LEDX<="0011111100";
			 when led4=>LEDX<="0111111110";
			 when led5=>LEDX<="1111111111";
			 when led6=>LEDX<="1111001111";
			 when led7=>LEDX<="1110000111";
			 when led8=>LEDX<="1100000011";
			 when led9=>LEDX<="1000000001";
			 when led10=>LEDX<="0000000000";
		 end case;
	 end if;
	 	if interr5='1' then	
			case mon_etat is	
			 when led1=>LEDX<="1000000000";
			 when led2=>LEDX<="1100000000";
			 when led3=>LEDX<="0110000000";
			 when led4=>LEDX<="0011000000";
			 when led5=>LEDX<="0001100000";
			 when led6=>LEDX<="0000000001";
			 when led7=>LEDX<="0000000011";
			 when led8=>LEDX<="0000000110";
			 when led9=>LEDX<="0000001100";
			 when led10=>LEDX<="0000011000";
		 end case;
	 end if;
	if interr6='1' then	
			case mon_etat is	
			 when led1=>LEDX<="0000000001";
			 when led2=>LEDX<="0000000011";
			 when led3=>LEDX<="0000000111";
			 when led4=>LEDX<="0000001110";
			 when led5=>LEDX<="0000011100";
			 when led6=>LEDX<="0000111000";
			 when led7=>LEDX<="0001110000";
			 when led8=>LEDX<="0011100000";
			 when led9=>LEDX<="1110000000";
			 when led10=>LEDX<="1000000000";
		 end case;
	 end if;

	 end process;																									

	
end comportement;																								--Fin du comportement de MLED
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------