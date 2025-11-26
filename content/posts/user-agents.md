+++
title = "Deep Dive on KaiOS User Agents"
description = "Analyzing hundreds of KaiOS user agent headers"
date = 2024-02-23T00:00:00+08:00
lastmod = 2024-12-07T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "User Agent"]
categories = []
series = ["Advanced Development"]
+++

## Deep Dive on KaiOS User Agents

**Why it matters**. User agents are one of the most common ways to identify devices on the web.

### Key Takeaways

User agents are a mess. Some are missing spaces, others missing model numbers, and others still include two OS identifiers (`Android` and `KAIOS`). They can also be easily spoofed, but they're still a useful mechanism to adapt your application at runtime or server-side.

* **KaiOS**
  * Every KaiOS device includes the `Mobile` identifier
  * All KaiOS devices include the identifier `KAIOS/` followed by the OS version (i.e. 2.5.3.2 or 3.2)
  * KaiOS 2.5 devices are based on the `Gecko` engine and `Firefox/48.0`; KaiOS 3.0 is based on `Firefox/84.0`
  * Some (but not all) KaiOS 2.5 devices with 256mb RAM have the `K-Lite` identifier
  * Many devices include the yet-unknown `CAEN` identifier
* **JioPhone**
  * Only JioPhone models have the `Android` identifier
  * All JioPhone models _except_ the latest [JioPhone Prima 4G (F491H)]({{< ref "whats-next-jiophone#jiophone-prima-4g" >}} "JioPhone Prima 4G (F491H)") include the `LYF` identifier
  * JioPhone user agents include the full [Build Identifier](https://source.android.com/docs/setup/reference/build-numbers), i.e. `LYF-LF2403N-001-02-23-170319`

### User Agents

Here's a list of `User-Agent` header values from recent requests to [PodLP](https://podlp.com/).

```
Mozilla/5.0 (Mobile; 3088X; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; ACCENT_NUBIA60K; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1 
Mozilla/5.0 (Mobile; ADVAN_2406_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALCATEL 4052C; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALCATEL 4052O; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2 
Mozilla/5.0 (Mobile; ALCATEL 4052R; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALCATEL 4052W; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALCATEL 4052Z; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALCATEL 4056W; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; ALCATEL 4056Z; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; ALCATEL A406DL; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; ALIGATOR_K50_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; ALPHA_B10_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; ASPERA_R40_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1 
Mozilla/5.0 (Mobile; ATT_EA211101; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; ATT_U102AA; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; ATT_U1030AA; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; AZUMI_L4K_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2.2
Mozilla/5.0 (Mobile; Accent_Nubia50K; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Alcatel_3078_3G; rv:48.0; K-Lite) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Azumi-L3K-3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Mango_AKABUTO_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; B300V; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; BLU_TankMega_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; BLU_TankMega_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; BLU_ZOEY_SMART; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; CAT B35; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; CAT B35; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1
Mozilla/5.0 (Mobile; CKT_U102AC; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3
Mozilla/5.0 (Mobile; CKT_U1030AC; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; CORN_Smart_K_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; CellAllure_Smart_Temp_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1 
Mozilla/5.0 (Mobile; Crosscall_Core-S4_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2 
Mozilla/5.0 (Mobile; Crosscall_Core-S4_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; DIXON_XK1_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; DORO7060; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; Digit_Digit4G-Bold_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; Digit_Digit4G-Defender_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G-Elite_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G-Music_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4GPowerMAX_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G-Power_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G-Star_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4GLite_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Digit_Digit4G_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Digit_Digit4G_Shine_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2 
Mozilla/5.0 (Mobile; Doppio_TEXTER_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; ENERGIZER_E241S; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; ENERGIZER_E280S; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Energizer_E241; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Energizer_E241S; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1 
Mozilla/5.0 (Mobile; Energizer_E242S_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Energizer_E282SC_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; ENERGIZER_H280A_512; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; FD07_MUNI_SMART; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Fise_32433_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; GEOPHONE_T19I_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; ORG_S232_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; GHIA_GK3G_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; GHIA_GQWERTY_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; GIGASET_GL7_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Geo_Phone_T15_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; Geo_Phone_T19_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; Hammer_5Smart_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; IDC_Voice_20_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; INOI_Q28F02-3_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; IPRO_I324MS4; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; IPRO_K2_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; Jio/F491H/Jio-F491H-001-06-24-271223;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Jio/F491H/Jio-F491H-EnterCalimode;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Jio/JFP1AE/Jio-JFP1AE-001-01-47-080524;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; LOGAN_Panita_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; LOGICOM_LK283_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; LOGICOM_LK284_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Logicom_Xtrem40_Pro_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; LOGIC_B8K_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; LOGIC_LOGIC_B8K_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2 
Mozilla/5.0 (Mobile; LYF/F101K/LYF-F101K-000-01-36-220518;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.0
Mozilla/5.0 (Mobile; LYF/F101K/LYF-F101K-000-02-40-220422;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F120B/LYF-F120B-001-02-66-191223;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F10Q/LYF-F10Q-000-01-34-080622; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F20A/LYF-F20A-000-01-52-291119;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F210Q/LYF-F210Q-000-00-14-110722; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F211S/LYF-F211S-000-02-14-130619; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F220B/LYF-F220B-003-01-19-240818;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F220B/LYF-F220B-003-01-38-170619_audio_log-i;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F221S/LYF-F221S-000-02-30-311019; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F250Y/LYF-F250Y-003-00-96-131219;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F250Y/LYF-F250Y-003-01-05-280423; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F271i/LYF_F271i-000-02-12-110422; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F300B/LYF-F300B-001-01-59-241121;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F30C/LYF_F30C-001-10-45-080822; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F320B/LYF-F320B-002-02-62-071022;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; LYF/F41T/LYF-F41T-000-02-04-100119; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F50Y/LYF-F50Y-000-03-02-270319;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F61F/LYF-F61F-000-02-02-251218; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F81E/LYF-F81E-000-02-42-260422; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/F90M/LYF_F90M_000-03-19-240319; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF-2403/LYF-LF2403S-001-02-19-031221;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF-2403N/LYF-LF2403N-001-02-23-170319;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF-2403N/LYF-LF2403N-001-02-0D-180619_audio_log-i;Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF2401/LYF-LF2401S-000-02-10-130220; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF2401S/LYF-JL-LF2401S-000-03-32-220523; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5 JioOSLite/11.0
Mozilla/5.0 (Mobile; LYF/LF-2406/LYF-LF2406S-000-02-09-120423; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; LYF/LF2402/LYF-LF2402S-000-02-14-200422; Android; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; Logicom_Kay_243_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; M560M3; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1
Mozilla/5.0 (Mobile; M561M3; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; M562F3; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; M571M3; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; MAXCOM_MK281_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; MOBICEL_S1_SMART; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2 
Mozilla/5.0 (Mobile; MS230_512_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; MS247_512; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; MS248_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; MS250J_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; MS250N_512_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; MS260_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2 
Mozilla/5.0 (Mobile; Multilaser_ZAPP; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Multilaser_ZAPP; rv:48.0; K-Lite) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Multilaser_ZAPP_II_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2 
Mozilla/5.0 (Mobile; N139DL; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; NOKIA_BEATLES; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Nokia 2720 Flip; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Nokia 2720 V Flip; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; Nokia 2780; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; Nokia 6300 4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; Nokia 8000 4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; Nokia_2720_Flip; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Nokia_2720_Flip; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2.2
Mozilla/5.0 (Mobile; Nokia_800_Tough; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Nokia_800_Tough; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2.2
Mozilla/5.0 (Mobile; Nokia_8110_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1
Mozilla/5.0 (Mobile; ORANGE_K2_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; Orange_it9301; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1 
Mozilla/5.0 (Mobile; Orbic_O4F231; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; P280_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; PCD_F2402_3G; rv:48.0;K-Lite) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; PLUM_E900_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; Positivo_P70S; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Q Innovations-Q28A; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Qmobile_4Gplus; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; SH3320; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; SIGMAMOBILE-S3500-3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; SPC_F15SE_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Safaricom_Kimem_Kerefa_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Sanza-M560F3; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1
Mozilla/5.0 (Mobile; Smart_M570S4; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Smart_Nano_II_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Symphony_PD1_4G_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; TCL 4056L; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; TCL 4056S; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; TCL 4056SPP; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; TCL 4056W; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.0
Mozilla/5.0 (Mobile; TCL T435WS; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; TCL T435SP; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; TCL T435D; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; TCL T435S; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; TCL T435X; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; TIM_TIM_Social_4G_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Tech_Pad_K_FLIP_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; Tech_Pad_Kaios_One_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Tech_Pad_Smart_K-4G_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Telma_Wi-Kif+3G_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Telma_Wi-Kif+4G_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Telma_Wikif_Max_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Free_Wi-Kif4G_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; Unitel_M42445_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; VGO_TEL_Smart_Hi-Fi_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; VIDA_ATOM_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; VIDA_VIDA-K242_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile; VMK_EM2_TS2402; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; WIKIFMAX4G_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; WINTEK_W209_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; WW6K25_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; WW6K27_512_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; WW6L2407_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; WW6_S2803_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Win_F3_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; Xandos_X5_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; fise-demo-3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; iKU_V400; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; i_PLUS_i4G_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; itel_it9300; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1 
Mozilla/5.0 (Mobile; myPhone_myPhone_Up_Smart_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile; myPhone_myPhone_Up_Smart_LTE_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; rv:48.0; A405DL) Gecko/48.0 Firefox/48.0 KAIOS/2.5
Mozilla/5.0 (Mobile; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; smart2.4S; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile;Orange_Nevalink;rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2
Mozilla/5.0 (Mobile;Orange_Nevamini;rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.2.1
Mozilla/5.0 (Mobile;Tecno_T901;rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0 (Mobile;Vodacom_Vibe4G;rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; Blackview_N1000_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; RED_X_RX2441_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; R3Di_FR150; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.4
Mozilla/5.0 (Mobile; Y9_TZ1_4G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.2
Mozilla/5.0 (Mobile; GPLUS_GNE-F002_4G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.3.1
Mozilla/5.0 (Mobile; BLACKPHONE_Blackphone_K330_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; HUAVI_H_111_3G; rv:48.0; CAEN) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; Bmobile_W125K_3G; rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile;Lanix_U340;rv:48.0) Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.1
Mozilla/5.0(Mobile;TECNO_T920D_4G;rv:48.0)Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0(Mobile;itel_it9200_4G;rv:48.0)Gecko/48.0 Firefox/48.0 KAIOS/2.5.1.2
Mozilla/5.0 (Mobile; HMD Barbie Phone; rv:84.0) Gecko/84.0 Firefox/84.0 KAIOS/3.1
Mozilla/5.0 (Mobile; rv:123.0) Gecko/123.0 Firefox/123.0 KAIOS/4.0
```

<u>Limitations</u>: these user agents are limited to a sample from a fixed time window, deduplicated on KaiOS version and build identifiers.

### Using User Agents

The most important distinction for a KaiOS application to make is to segment users originating from the KaiStore (global) and the JioStore (JioPhone in India). Here's a code snippet for detecting if the KaiOS device is a JioPhone or not:

```js
function isJioPhone() {
    const normalizedUserAgent = (navigator.userAgent || '').toLowerCase();
    return (
        normalizedUserAgent.includes('lyf')     // All other JioPhone models
        || normalizedUserAgent.includes('jio')  // JioPhone Prima 4G (F491H)
    );
}
```

User agents can also be used for check KaiOS version (2.5 vs 3.0), although [feature detection]({{< ref "feature-detection" >}} "feature detection") and runtime checks for specific APIs are a more reliable way to accomplish version detection.

Finally, user agents could be used in contexts where [feature detection]({{< ref "feature-detection" >}} "feature detection") isn't available to identify information like the device model and manufacturer. From the list above, popular KaiOS manufacturers include: Nokia, Jio (LYF), Alcatel, Blu, CrossCall, Digit, Energizer, Logicom, Multilaser, Orange, Orbic, TCL, and Tecno.

## Conclusion

User agents are a simple and easy way to adapt your app or website to a variety of devices. While it's ideal to use [feature detection]({{< ref "feature-detection" >}} "feature detection"), knowing the gamut of available user agents helps determine the most reliable identifiers for segmentation or behavior change. If you need support adapting your website or PWA for KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.
